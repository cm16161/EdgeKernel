require 'rubygems'
require 'redis'
require 'json'
require 'redis-queue'
require 'net/http'
require 'pty'
require 'usagewatch_ext'


def check_webdis()
  uri = URI('http://192.168.0.37:7379/GET/hello')
  response = Net::HTTP.get_response(uri)
  if response.code != '200' then
    fork{
      exec("echo test;cd ../webdis; ./webdis")
    }
    return false
  end
  return true
end

def load_kernels_to_memory()
  fork{
    exec("vmtouch -tq ../Kernels/")
  }
end


def fill_queues(queue, name)
      for q in queue do
        if $queues[q].length == 0 then
          $queues[q] = [name]
        else
          $queues[q].append(name)
        end
      end
end


# Map between queues and which unikernels to boot when data is recieved on that queue
$queues = Hash.new([])

# Map between the unikernel to run and where to find it
$directories = {}

# Map between the unikernel to run and the file to store its output
$ofiles = {}

# Map between the unikernel to run and the maximum number of instances of it
$kernel_limit = Hash.new(1)

# Map between the unikernel and the number of instances currently running
$active_kernels = Hash.new(0)

# Map between the unikernel and whether or not it has any output files which need aggregating
$has_output = Hash.new(false)

#Map between the unikernel and the how large the queue needs to be before a new instance can spawn
$scale_thresholds = Hash.new(10)

#Map between the unikernel and the time it needs to wait in seconds between each new instance is spawned
$grace_period = Hash.new(0)

$binary_type = Hash.new("mirageos")


$tap_interfaces = []

# # List of Channels to link the Redis Queue object with its Name
# $channels = []

$base_dir =  Dir.pwd

$mutex = Mutex.new

$usw = Usagewatch

def register_unikernels()
  Dir.chdir('config')
  files = Dir.glob("*.json")
  for f in files do
    json = JSON.parse(File.read(f))
    name = json["name"]
    dir = json["directory"]
    queue = json["queue"]
    ofile = json["ofile"]
    limit = json["max_instances"]
    threshold = json["scale_threshold"]
    binary_type = json["binary"]
    fill_queues(queue, name)
    
    $directories[name] = dir
    if limit then
      $kernel_limit[name] = limit
    end
    if threshold then
      $scale_thresholds[name] = threshold
    end
    if binary_type then
      $binary_type[name] = binary_type
    end
    $ofiles[name] = ofile
  end
end


def establish_channels()
  channels = []
  # Redis Object
  $redis = Redis.new(:timeout => 0)
  $queues.each do | key, value |
    null_process_queue = key + "_null_process_queue"
    channels.append([Redis::Queue.new(key, null_process_queue, :redis=> $redis), key])
    # channels.append(["", key])
  end
  return channels
end


def generate_tap_list()
  for i in 2..10 do
    tapN = "tap1000".concat(i.to_s)
    ipN = "10.0.0.".concat(i.to_s).concat("/24")
    $tap_interfaces.append([tapN, ipN, true])
  end
end

def execute_kernel(kernel, part_count, tap_index)
  Dir.chdir($directories[kernel])
  if $binary_type[kernel].eql? "bash" then
    command = "./"+ kernel
  else
    command = "solo5-hvt --net:service=" + $tap_interfaces[tap_index][0] + "  -- " + kernel + " --ipv4="+ $tap_interfaces[tap_index][1] + " --ipv4-gateway=10.0.0.1"
  end

  ofile = $base_dir + "/output/" + $ofiles[kernel] + ".part."+part_count

  PTY.spawn( command ) do |stdout, stdin, pid|
    open(ofile, "a") do |f|
      stdout.each { |line| f.puts line }
    end      
    rescue Errno::EIO
  end
  $mutex.synchronize do
    $active_kernels[kernel] -= 1
    $grace_period[kernel] = 0
    $tap_interfaces[tap_index][2] = true
  end
    puts "Finished"
end

def get_tap_device()
  for i in 0 .. $tap_interfaces.length-1 do
    if $tap_interfaces[i][2] then
      return i
    end
  end
  return -1
end

def init()
  active = check_webdis()
  while !active do
    active = check_webdis()
  end
  load_kernels_to_memory()
  generate_tap_list()
  register_unikernels()
  # load_channels()

end

def combine_logs(kernel)
  ofile = $base_dir + "/output/" + $ofiles[kernel]
  open(ofile, 'a'){ |f|
    Dir.glob($base_dir + "/output/" + $ofiles[kernel] + ".*").sort.each{ |file|
      f.puts File.readlines(file)
      File.delete(file)
    }
  }
  $has_output[kernel] = false
end

def terminate_on(c, target,u,ts)
if c[1] == target then
          if c[0].empty? and $active_kernels[u] == 0 then
            finished = (`date +%s%N`.to_i - ts)/1000000
            puts finished
            exit 0
          end
        end
end

def server()
  # prev_val = `ps -o rss= -p #{$$}`.to_i
  ts= `date +%s%N`.to_i
  loop do
#    puts $usw.uw_cpuused
    # val =  `ps -o rss= -p #{$$}`.to_i
    # if prev_val != val then
    #   puts val
    #   prev_val = val
    # end
    channels = establish_channels()
    for c in channels do
      queue_name = c[1]
      for u in $queues[queue_name] do
        # terminate_on(c, "eval_alert_input",u,ts)
        if c[0].empty? then
          if $has_output[u] and $active_kernels[u] == 0 then
            combine_logs(u)
          end
        else
          queue_count = c[0].length
          if $active_kernels[u] > queue_count/$scale_thresholds[u] then
            # puts "wait to finish before creating new"
            next
          else
            if $active_kernels[u] >= $kernel_limit[u] then
              "Limit Met, allow existing to terminate"
              next
            elsif $grace_period[u] + 1 > Time.now.to_i then
              puts "Still within grace-period, please wait"
            else
              tap_index = get_tap_device()
              if tap_index == -1 then
                puts "No Tap Device available"
                next
              end
              $mutex.synchronize do
                $active_kernels[u] += 1
                $grace_period[u] = Time.now.to_i
                $tap_interfaces[tap_index][2] = false
              end
              # When starting a new thread, the next iteration of the loop executes
              # and so this line is needed to ensure the correct unikernel boots
              kernel = u
              $has_output[kernel] = true
              Thread.new{
               # puts "SPAWNING " + kernel
                execute_kernel(kernel, $active_kernels[kernel].to_s, tap_index)
              }
            end
          end
        end
      end
    end
  end
end

def main()
  init()
  server()

end

main()
