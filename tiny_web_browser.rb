	require "socket"
	require "json"

	host = "localhost" #the web server
	port = 2000 #default http port

	puts "Do you want to get something or post something?"
	user_action = gets.chomp.downcase
	if user_action ==  "get" #this works as far as I can tell
		puts "Enter filename like this: /???.???"
		path = gets.chomp.downcase #the file we want
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
	elsif user_action == "post"
	 	puts "Welcome to viking registration.  What is the name of your viking?"
		name = gets.chomp.capitalize
		puts "What is your viking's email?"
		email = gets.chomp.downcase
		new_viking_info = {:name => name, :email => email}
		new_viking = {:viking => new_viking_info}
		new_viking = new_viking.to_json
		socket = TCPSocket.open(host, port)
		request = "POST localhost HTTP/1.0\r\n"
		request += "Date: #{Time.now.ctime}\r\n"
		request += "Content-Type: text/html\r\n"
		request += "Content-Length: #{new_viking.length}\r\n"
		request += "Content-Length: #{4}\r\n"
		request += "\r\n"
		request += new_viking
		socket.print(request)
		response = socket.recv(1024) #read complete response
		puts response
		#split response at first blank line into headers and body
#		headers, body = response.split("\r\n\r\n", 2)
#		header_lines = headers.split("\r\n")
#		if /1\.0\s4../.match(header_lines[0])
#			puts "#{header_lines[0]}"
		#	print body #and display it
		#end

		#it's trying to read the response that's causing it to barf on both parts now
	
	else 
		puts "I can only get or post.  Goodbye!"
end

#having trouble separating this into methods, which I feel pretty stupid about
#also not sure how to set up post. not sure what goes in the middle of the top line