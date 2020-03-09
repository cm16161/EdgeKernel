require 'rubygems'
require 'redis'
require 'json'

$redis = Redis.new(:timeout => 0)

$redis.subscribe('rubyonrails', 'test', 'hello', 'echo_server') do |on|
  on.message do |channel, msg|
    data = JSON.parse(msg)
    puts "#{channel} - [#{data['user']}]: #{data['msg']}"
    if channel.eql? "echo_server"
      if data['msg'].eql? "start"
        Dir.chdir('../../echo_server/build'){
          command = "boot --create-bridge --with-solo5-hvt tcp_service #{msg}; exit"
          r = IO.popen("bash", "r+")
          r.write "#{command}\n"
          while line = r.gets do
            puts(line)
          end
        }
      end
    end
  end
end
