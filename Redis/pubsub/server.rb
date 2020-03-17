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
    #next if f == '.' or f == '..'
#    tmp = File.read(f)
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

puts $queues
puts $directories
puts $ofiles


# $redis = Redis.new(:timeout => 0)
# echo_queue = Redis::Queue.new('echo','null_process_queue', :redis=> $redis)
# loop do
#   if echo_queue.empty?
#     next
#   else
#     Dir.chdir("../../echo/build")
#       command = "boot --with-solo5-hvt echo; exit"
#       r = IO.popen("bash","r+")
#       r.write "#{command}\n"
#       while line = r.gets do
#         puts line
#     end
#   end
# end
