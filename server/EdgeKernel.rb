require 'rubygems'
require 'redis'
require 'json'
require 'redis-queue'
require 'net/http'
require 'pty'
require 'usagewatch_ext'
require 'timeout'
require 'csv'
require 'socket'
def check_webdis
  ip = Socket.ip_address_list.detect(&:ipv4_private?)&.ip_address
  uri = 'http://' + ip.to_s + ':7379/GET/hello'
  uri = URI(uri)
  response = Net::HTTP.get_response(uri)
  if response.code != '200'
    fork { exec('echo error;cd ../webdis; ./webdis') }
    check_webdis
  end
  return
end

def load_kernels_to_memory
  fork { exec('vmtouch -tq ../Kernels/') }
end

def fill_queues(queue, name)
  queue.each do |q|
    if $queues[q].empty?
      $queues[q] = [name]
    else
      $queues[q].append(name)
    end
  end
end

# Map between queues and which unikernels to boot when data is recieved on that
# queue
$queues = Hash.new([])

# Map between the unikernel to run and where to find it
$directories = {}

# Map between the unikernel to run and the file to store its output
$ofiles = {}

# Map between the unikernel to run and the maximum number of instances of it
$kernel_limit = Hash.new(1)

# Map between the unikernel and the number of instances currently running
$active_kernels = Hash.new(0)

# Map between the unikernel and whether or not it has any output files which
# need aggregating
$has_output = Hash.new(false)

# Map between the unikernel and the how large the queue needs to be before a new
# instance can spawn
$scale_thresholds = Hash.new(10)

# Map between the unikernel and the time it needs to wait in seconds between
# each new instance is spawned
$grace_period = Hash.new(0)

# Map bewtween the unikernel and the platform which it runs on, default is
# MirageOS unikernels on Solo5

$binary_type = Hash.new('mirageos')

# List of tap devices available
$tap_interfaces = []

$base_dir = Dir.pwd

$mutex = Mutex.new

$usw = Usagewatch

def get_metadata(f)
  json = JSON.parse(File.read(f))
  name = json['name']
  dir = json['directory']
  queue = json['queue']
  ofile = json['ofile']
  limit = json['max_instances']
  threshold = json['scale_threshold']
  binary_type = json['binary']
  [name, dir, queue, ofile, limit, threshold, binary_type]
end

def assign_directory(dir, name)
  $directories[name] = (__dir__ + '/../' + dir).to_s
end

def define_limit(limit, name)
  if limit
    $kernel_limit[name] = limit
  end
end

def define_scale_threshold(threshold, name)
  if threshold
      $scale_thresholds[name] = threshold
  end
end

def specify_binary(binary_type, name)
  if binary_type
      $binary_type[name] = binary_type
  end
end

def assign_ofile(ofile, name)
  $ofiles[name] = ofile
end

def create_mappings(name, dir, queue, ofile, limit, threshold, binary_type)
  fill_queues(queue, name)
  assign_directory(dir, name)
  define_limit(limit, name)
  define_scale_threshold(threshold, name)
  specify_binary(binary_type, name)
  assign_ofile(ofile, name)
end

def register_unikernels
  Dir.chdir('config')
  files = Dir.glob('*.json')
  files.each do |f|
    name, dir, queue, ofile, limit, threshold, binary_type = get_metadata(f)

    create_mappings(name, dir, queue, ofile, limit, threshold, binary_type)
  end
end

$redis = Redis.new

def establish_channels
  channels = []
  $queues.each_key do |key|
    null_process_queue = key + '_null_process_queue'
    channels.append([Redis::Queue.new(key, null_process_queue, :redis => $redis),
                     key])
  end
  channels
end

def generate_tap_list
  for i in 2..51 do
    tapN = 'tap1000'.concat(i.to_s)
    ipN = '10.0.0.'.concat(i.to_s).concat('/24')
    $tap_interfaces.append([tapN, ipN, true])
  end
end

def generate_command(kernel, tap_index)
  if $binary_type[kernel].eql? 'bash'
    './' + kernel
  else
    'solo5-hvt --net:service=' + $tap_interfaces[tap_index][0] +
      ' -- ' +
      kernel +
      ' --ipv4=' +
      $tap_interfaces[tap_index][1] +
      ' --ipv4-gateway=10.0.0.1'
  end
end

def execute_kernel(kernel, part_count, tap_index)
  Dir.chdir($directories[kernel])
  command = generate_command(kernel, tap_index)
  ofile = $base_dir + '/output/' + $ofiles[kernel] + '.part.' + part_count
  puts 'Executing'
  PTY.spawn(command) do |stdout, _stdin, pid|
    begin
      Timeout.timeout(1) {
        open(ofile, 'a') do |f|
          stdout.each { |line| f.puts line }
        end
      }
    rescue Errno::EIO
    rescue Timeout::Error
      Process.kill(9, pid)
    end
  end
end

def get_tap_device
  for i in 0..($tap_interfaces.length - 1) do
    if $tap_interfaces[i][2]
      return i
    end
  end
  -1
end

def init
  check_webdis
  load_kernels_to_memory
  generate_tap_list
  register_unikernels
end

def combine_logs(kernel)
  ofile = $base_dir + '/output/' + $ofiles[kernel]
  open(ofile, 'a') { |f|
    Dir.glob($base_dir + '/output/' + $ofiles[kernel] + '.*').sort.each { |file|
      f.puts File.readlines(file)
      File.delete(file)
    }
  }
  $has_output[kernel] = false
end

# Function used to terminate EdgeKernel when a queue is empty and report
def terminate_on(c, target ,u, ts)
  if c[1] == target
    if c[0].empty? && $active_kernels[u].zero?
      finished = (`date +%s%N`.to_i - ts) / 1_000_000
      puts finished
      exit 0
    end
  end
end

def update_state(u, tap_index)
  $mutex.synchronize do
  $active_kernels[u] += 1
  $grace_period[u] = Time.now.to_i
  $tap_interfaces[tap_index][2] = false
  end
end

def begin_execution(u, tap_index)

  # When starting a new thread, the next iteration of the loop
  # executes and so this line is needed to ensure the correct
  # unikernel boots
  kernel = u
  $has_output[kernel] = true

  puts 'SPAWNING ' + kernel
  Thread.new(kernel, tap_index) { |kernel, tp|
    execute_kernel(kernel, $active_kernels[kernel].to_s, tp)
    $mutex.synchronize do
      puts 'Finished'
      $active_kernels[kernel] -= 1
      $grace_period[kernel] = 0
      $tap_interfaces[tp][2] = true
    end
  }
  
end

def check_output(u)
    if $has_output[u] and $active_kernels[u] == 0
      combine_logs(u)
    end
end


def check_scaling(c, u)
  queue_count = c[0].length
  if $active_kernels[u] > queue_count/$scale_thresholds[u] then
    puts 'wait to finish before creating new'
    true
  end
  false
end

def check_limit(u)
  if $active_kernels[u] >= $kernel_limit[u]
    'Limit Met, allow existing to terminate'
    return true
  end
  false
end


def check_grace_period(u, grace_period)
  if $grace_period[u] + grace_period > Time.now.to_i
    puts 'Still within grace-period, please wait'
    return true
  end
end

def check_tap(tap_index)
  if tap_index == -1
    puts 'No Tap Device available'
    return true
  end
  false
end

def monitor_queue(c, u)
  if c[0].empty?
    check_output(u)
  end

  if check_scaling(c, u)
    return
  end

  if check_limit(u)
    return
  end

  if check_grace_period(u, 1)
    return
  end
  tap_index = get_tap_device

  if check_tap(tap_index)
    return
  end
  update_state(u, tap_index)
  begin_execution(u, tap_index)
end

def monitor_channel(c)
  queue_name = c[1]
  for u in $queues[queue_name] do
    monitor_queue(c, u)
  end
end

def server
  loop do
    check_webdis
    channels = establish_channels
    for c in channels do
      monitor_channel(c)
    end
  end
end

def main
  init
  server
end

main
