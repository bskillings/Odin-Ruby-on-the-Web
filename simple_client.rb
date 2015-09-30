require "socket"  #sockets are in standard library

hostname = "localhost"
port = 2000

s = TCPSocket.open(hostname, port)

while line = s.gets #read lines from the socket
	puts line.chop #and print with the platform line terminator
end
s.close #close the socket when done