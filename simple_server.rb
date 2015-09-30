require "socket"#get sockets from stdlib

server = TCPServer.open(2000) #socket to listen on port 2000
loop {  #servers run forever
	client = server.accept #wait for a client to connect
	request = client.gets.chomp
	request_split = request.split(" ")
	if (request_split[0] == "GET") && /index\.html/.match(request_split[1]) #working
		response = ""
		filename = request_split[1]
		filename.slice!(0)#taking / off front
		if File.file?(filename)
			file_text = File.open(filename, "r").read
			client.print "HTTP/1.0 200 OK\r\n"
			client.print "Date : #{Time.now.ctime}\r\n"
			client.print "Content-Length: #{file_text.length}\r\n"
			client.print "\r\n"
			client.print file_text
		else
			client.print "HTTP/1.0 404 File Not Found"
		end
	else
		client.print "HTTP/1.0 404 File Not Found"
	end
	client.puts ""
	client.puts (Time.now.ctime) #send the time to the client why isn't it doing this anymore?
	client.puts "Closing the connection.  Bye!"
	client.close #disconnect from the client
}

#modify to take the HTTP request from the browser and if it is a get request that points to /index.html, send back the contents of my index file
#parse incoming request
#send proper HTTP response