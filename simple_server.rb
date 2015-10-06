require "socket"#get sockets from stdlib
require "json"
require "erb"

server = TCPServer.open(2000) #socket to listen on port 2000
loop {  #servers run forever
	client = server.accept #wait for a client to connect
	request = client.recv(1024) #only the first line is coming through
	puts request
	request_split = request.split(" ")
	if (request_split[0] == "GET") #working
		response = ""
		filename = request_split[1]
		filename.slice!(0)#taking / off front
		puts filename
		if File.file?(filename)
			file_text = File.open(filename, "r").read
			puts "File: #{file_text}"
			client.print "HTTP/1.0 200 OK\r\n"
			client.print "Date : #{Time.now.ctime}\r\n"
			client.print "Content-Length: #{file_text.length}\r\n"
			client.print "\r\n"
			client.print file_text
		else
			client.print "HTTP/1.0 404 File Not Found"
		end
	elsif (request_split[0] == "POST")
		puts "got a post request"
		puts request
		#split response at first blank line into headers and body
		headers, body = request.split("\r\n\r\n", 2)
		header_lines = headers.split("\r\n")
		params = JSON.parse(body)
		vikings =  params["viking"]
		viking_elements = ""
		vikings.each {|k, v| viking_elements += "<li> #{k}: #{v}</li>"}
		thanks_page = File.read("thanks.html")
		this_thanks = thanks_page.gsub("<%= yield %>", viking_elements)
		send_me = "HTTP/1.0 200 OK\r\nDate : #{Time.now.ctime}\r\n\r\n#{this_thanks}"
		puts send_me
		client.print send_me
		#	client.print "Date : #{Time.now.ctime}\r\n"
	#	client.print "Content-Length: #{file_text.length}\r\n"
	#	client.print "\r\n"
	#	client.print this_thanks
		#this is barfing again
	else
		client.print "HTTP/1.0 404 File Not Found (bad request)"
	end
#	client.puts ""
#	client.puts (Time.now.ctime) #send the time to the client why isn't it doing this anymore?
#	client.puts "Closing the connection.  Bye!"
	client.close #disconnect from the client
}

	