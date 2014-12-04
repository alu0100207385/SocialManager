module AppHelpers
   def my_twitter_client (ck,cs,at,ats)
	  Twitter::REST::Client.new do |config|
		 config.consumer_key = ck
		 config.consumer_secret = cs
		 config.access_token = at
		 config.access_token_secret = ats
	  end
   end
end
# http://127.0.0.1/auth/twitter/callback
# http://socialmanager.herokuapp.com/auth/twitter/callback