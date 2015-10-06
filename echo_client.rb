#This is a client for very basic getting and posting

require "socket"

hostname = "localhost"
port = 2000

s = TCPSocket.open(hostname, port)
s.puts "I am a potato"
puts s.read
#while line = s.gets
#	puts line.chop
#end
s.close