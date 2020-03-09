require 'rubygems'
require 'redis'
require 'json'


msg = '{"user":"chetan","msg":"start"}'

Dir.chdir('/home/chetan/Documents/hello_world/build'){
  command = "boot hello #{msg}; exit"
  puts command
  r = IO.popen("bash", "r+")
  r.write "#{command}\n"
  while line = r.gets do
    puts(line)
  end
}
