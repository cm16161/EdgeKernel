require 'rubygems'
require 'redis'
require 'json'
require 'redis-queue'
require 'net/http'


def check_webdis()
  # uri = URI('http://127.0.0.1:7379/GET/hello')
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
    exec("vmtouch -vtdl ../Kernels/")
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


# List of Channels to link the Redis Queue object with its Name
$channels = []

# Redis Object
$redis = Redis.new(:timeout => 0)

$base_dir =  Dir.pwd

$mutex = Mutex.new

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
    fill_queues(queue, name)

    $directories[name] = dir
    if limit then
      $kernel_limit[name] = limit
    end

    $ofiles[name] = ofile
  end
end


def load_channels()
  $queues.each do | key, value |
    null_process_queue = key + "_null_process_queue"
    $channels.append([Redis::Queue.new(key, null_process_queue, :redis=>$redis), key])
  end
end

def execute_kernel(kernel, part_count)
  Dir.chdir($directories[kernel])
  # command = "boot "+ kernel+ "; exit"
  command = "solo5-hvt --net:service=tap100 -- " + kernel + "; exit"
  r = IO.popen("bash","r+")
  r.write "#{command}\n"
  ofile = $base_dir + "/output/" + $ofiles[kernel] + ".part."+part_count
  open(ofile, "a") do |f|
    while line = r.gets do
      f.puts line
    end
  end
  $mutex.synchronize do
    $active_kernels[kernel] -= 1
  end
    puts "Finished"
end

def init()
  active = check_webdis()
  while !active do
    active = check_webdis()
  end

  load_kernels_to_memory()
  register_unikernels()
  load_channels()

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

def main()
  init()
  loop do
    for c in $channels do
      queue_name = c[1]
      for u in $queues[queue_name] do
        if c[0].empty? then
          if $has_output[u] and $active_kernels[u] == 0 then
            combine_logs(u)
          end
        else
          if $active_kernels[u] >= $kernel_limit[u] then
            next
          else
            $mutex.synchronize do
              $active_kernels[u] += 1
            end
            # When starting a new thread, the next iteration of the loop executes
            # and so this line is needed to ensure the correct unikernel boots
            kernel = u
            $has_output[kernel] = true
            Thread.new{
              puts "SPAWNING " + kernel
              execute_kernel(kernel, $active_kernels[kernel].to_s)
            }
          end
        end
      end
    end
  end
end

main()
