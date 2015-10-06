class SimpleServer

	require "socket"#get sockets from stdlib
	require "json"

	def initialize

		server = TCPServer.open(2000) #socket to listen on port 2000
		loop {  #servers run forever
			@client = server.accept #wait for a client to connect
			@request = @client.recv(2048) #only the first line is coming through
			puts @request
			@request_split = @request.split(" ")
			if (@request_split[0] == "GET") then respond_to_get
			elsif (@request_split[0] == "POST") then respond_to_post
			else
				@client.print "HTTP/1.0 404 File Not Found (bad request)"
			end
			@client.puts ""
			@client.puts (Time.now.ctime) #send the time to the client 
			@client.puts "Closing the connection.  Bye!"
			@client.close #disconnect from the client
		}
	end

	def respond_to_get
		filename = @request_split[1]
		filename.slice!(0)#taking / off front
		puts filename
		if File.file?(filename)
			file_text = File.open(filename, "r").read
			puts "File: #{file_text}" #building the response
			@client.print "HTTP/1.0 200 OK\r\n"
			@client.print "Date : #{Time.now.ctime}\r\n"
			@client.print "Content-Length: #{file_text.length}\r\n"
			@client.print "\r\n"
			@client.print file_text
		else
			@client.print "HTTP/1.0 404 File Not Found"
		end
			
	end

	def respond_to_post
		puts "got a post request"
		#split response at first blank line into headers and body
		headers, body = @request.split("\r\n\r\n", 2)
		header_lines = headers.split("\r\n")
		params = JSON.parse(body)
		vikings =  params["viking"]
		viking_elements = ""
		vikings.each {|k, v| viking_elements += "<li> #{k}: #{v}</li>"}
		thanks_page = File.read("thanks.html")
		this_thanks = thanks_page.gsub("<%= yield %>", viking_elements) #swapping text for yield
		@client.print "HTTP/1.0 200 OK \r\n" #building the response
		@client.print "Date : #{Time.now.ctime}\r\n"
		@client.print "Content-Length: #this_thanks.length}\r\n"
		@client.print "\r\n"
		@client.print this_thanks
	end

end

server = SimpleServer.new
