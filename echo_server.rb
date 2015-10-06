#This is a server for testing the concept of getting and posting

require "socket"

server = TCPServer.open(2000)
loop {
	client = server.accept
	message = client.gets
	puts "Message received: #{message}"
	client.puts "You said #{message}"
	client.puts(Time.now.ctime)
	client.puts "closing connection"
	client.close
}