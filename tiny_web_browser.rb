require "socket"

host = "localhost" #the web server
port = 2000 #default http port
path = "/index.html" #the file we want

#this is the HTTP request we send to fetch a file
request = "GET #{path} HTTP/1.0\r\n\r\n"

socket = TCPSocket.open(host, port) #connect to server
socket.print(request) #send request
response = socket.read #read complete response
#split response at first blank line into headers and body
headers, body = response.split("\r\n\r\n", 2)
header_lines = headers.split("\r\n")
if /1\.0\s4../.match(header_lines[0])
	puts "#{header_lines[0]}"
else
	print body #and display it
end