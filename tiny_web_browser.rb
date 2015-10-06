class TinyBrowser

	require "socket"
	require "json"

	def initialize

		@host = "localhost" #the web server
		@port = 2000 #default http port

		puts "Do you want to get something or post something?"
		user_action = gets.chomp.downcase
		if user_action ==  "get" then @response = get_something
		elsif user_action == "post" then @response = post_something
		else 
			puts "I can only get or post.  Goodbye!"
		end
	end

	def get_something
		puts "Enter filename like this: /???.???"
		path = gets.chomp.downcase #the file we want
		
		@request = "GET #{path} HTTP/1.0\r\n\r\n" #get request is simple

		talk_to_socket

		print_response
	end

	def post_something
		puts "Welcome to viking registration.  What is the name of your viking?"
		name = gets.chomp.capitalize
		puts "What is your viking's email?"
		email = gets.chomp.downcase
		new_viking_info = {:name => name, :email => email}
		new_viking = {:viking => new_viking_info}
		new_viking = new_viking.to_json
		
		@request = "POST localhost HTTP/1.0\r\n"#building request into one string
		@request += "Date: #{Time.now.ctime}\r\n"
		@request += "Content-Type: text/html\r\n"
		@request += "Content-Length: #{new_viking.length}\r\n"
		@request += "\r\n"
		@request += new_viking
		
		talk_to_socket

		print_response
	end

	def talk_to_socket
		@socket = TCPSocket.open(@host, @port)
		@socket.print(@request)

	end

	def print_response
		@response = @socket.recv(1024) #read complete response
		#split response at first blank line into headers and body
		headers, body = @response.split("\r\n\r\n", 2)
		header_lines = headers.split("\r\n")
		if /1\.0\s4../.match(header_lines[0])
			puts "#{header_lines[0]}"
		else
			print body #and display it
		end	
	end
end

browser = TinyBrowser.new