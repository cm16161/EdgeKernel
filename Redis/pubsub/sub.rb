require 'rubygems'
require 'redis'
require 'json'
require 'redis-queue'


$redis = Redis.new(:timeout => 0)
echo_queue = Redis::Queue.new('echo','null_process_queue', :redis=> $redis)
loop do
  if echo_queue.empty?
    next
  else
    Dir.chdir("../../echo/build")
      command = "boot --with-solo5-hvt echo; exit"
      r = IO.popen("bash","r+")
      r.write "#{command}\n"
      while line = r.gets do
        puts line
    end
  end
end
