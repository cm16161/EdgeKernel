require 'rubygems'
require 'redis'
require 'json'
require 'redis-queue'

# Map between queues and which unikernels to boot when data is recieved on that queue
$queues = Hash.new([])

# Map between the unikernel to run and where to find it
$directories = {}

# Map between the unikernel to run and the file to store its output
$ofiles = {}

$base_dir =  Dir.pwd


def fill_queues(queue, name)
      for q in queue do
        if $queues[q].length == 0 then
          $queues[q] = [name]
        else
          $queues[q].append(name)
        end
      end
end


def register_unikernels()
  Dir.chdir('config')
  files = Dir.glob("*.json")
  for f in files do
    json = JSON.parse(File.read(f))
    name = json["name"]
    dir = json["directory"]
    queue = json["queue"]
    ofile = json["ofile"]

    fill_queues(queue, name)

    $directories[name] = dir
    $ofiles[name] = ofile
  end
end

register_unikernels()

$redis = Redis.new(:timeout => 0)

$channels = []
$queues.each do | key, value |
  null_process_queue = key + "_null_process_queue"
  $channels.append([Redis::Queue.new(key, null_process_queue, :redis=>$redis), key, false])
end

loop do
  for c in $channels do
    if c[0].empty? then
      next
    else if c[2] == true then
      puts "running"
      next
    else
      c[2] = true
      queue_name = c[1]
      for u in $queues[queue_name] do
          Dir.chdir($directories[u])
          command = "boot "+ u+ "; exit"
          r = IO.popen("bash","r+")
          r.write "#{command}\n"
          ofile = $base_dir + "/output/" + $ofiles[u]
          open(ofile, "a") do |f|
            while line = r.gets do
              f.puts line
            end
            end
      end
      c[2] = false
      end
    end
  end
end
