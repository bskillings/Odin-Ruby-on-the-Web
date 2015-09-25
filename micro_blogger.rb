require "jumpstart_auth"
require "bitly"

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing MicroBlogger"
		@client = JumpstartAuth.twitter
	end

	def tweet(message)
		if message.length <= 140
			@client.update(message)
		else
			puts "message too long"
		end
	end

	def run
		puts "Welcome to the JSL Twitter Client!"
		command = ""
		while command != "q"
			printf "enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]
			case command
			when "q" then puts "Goodbye!"
			when "t" then tweet(parts[1..-1].join(" "))
			when "dm" then dm(parts[1], parts[2..-1].join(" "))
			when "spam" then spam_my_followers(parts[1..-1].join(" "))
			when "elt" then everyones_last_tweet
			when "s" then shorten(parts[1])
			when "turl" then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
			else
				puts "Sorry, I don't know how to #{command}"
			end
		end
	end

	def dm(target, message)
		screen_names = @client.followers.collect {|follower| @client.user(follower).screen_name}
		puts "Trying to send #{target} this direct message:"
		puts message
		if screen_names.include?(target)
			message = "d #{target} #{message}"
			tweet(message)
		else
			puts "You can only dm people that follow you"
		end
	end

	def followers_list
		screen_names = []
		@client.followers.each do |follower|
			screen_names << @client.user(follower).screen_name
		end
		return screen_names
	end

	def spam_my_followers(message)
		followers = followers_list
		followers.each {|follower| dm(follower, message)}

	end

	def everyones_last_tweet #the problem seems to be that the friends is not an array
		#I can't sort because it's not an array.  I could change it to an array but maybe later

		friends = @client.friends
		friends_array = []
		friends.each do |friend|
			friends_array.push(friend)
		end
		friends_array.sort! {|a, b| a.screen_name.downcase <=> b.screen_name.downcase}
		friends_array.each do |friend|
			message = @client.user(friend).status.text #this was wrong
			timestamp = @client.user(friend).status.created_at
			puts "On #{timestamp.strftime("%A, %b, %d")}, #{@client.user(friend).screen_name} said..." #this also
			puts message
			puts "" 
		end
	end

	def shorten(original_url)
		puts "Shortening this URL: #{original_url}"
		Bitly.use_api_version_3
		bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
		return bitly.shorten(original_url).short_url
	end
end

blogger = MicroBlogger.new
blogger.run