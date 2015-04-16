require 'redd'

class BrSpellBot

	def execute
		begin
			auth
			dig!
		rescue Redd::Error::RateLimited => error
			puts error
			puts "waiting..."
		  	sleep(error.time)
		  	retry
		rescue Redd::Error => error
		  	# 5-something errors are usually errors on reddit's end.
		  	raise error unless (500...600).include?(error.code)
		  	puts error
		  	retry
		rescue Faraday::SSLError => error
			puts error
			puts "waiting..."
			sleep(5000)
			retry
		rescue Exception => error
			puts error
			sleep(5000)
			retry
		end

	end

	def auth
		# Authorization
		@r = Redd.it(:script, "CLIENT_ID", "SECRET", "Unidan", "hunter2", user_agent: "BRSpellBot v1.0.0")
		@r.authorize!
	end

	def dig!
		@r.stream :get_comments, "brasil" do |comment|
	    	#comment.reply("World!") if comment.body == "Hello?"
	    	if comment.body =~ /(presidenta)/
    			puts comment.body 
    			comment.reply("Presidente")
    			puts "Replied!"
	    	end
	    	
		end
	end

end


bot = BrSpellBot.new
bot.execute
