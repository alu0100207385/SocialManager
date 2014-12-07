module AppHelpers
  require 'mail'
  
   def my_twitter_client (ck,cs,at,ats)
	  Twitter::REST::Client.new do |config|
		 config.consumer_key = ck
		 config.consumer_secret = cs
		 config.access_token = at
		 config.access_token_secret = ats
	  end
   end
   def my_facebook_client()
   end
   
   def sendmail(dir)
     sm='social.manager.info@gmail.com'
     options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'socialmanager.herokuapp.com',
            :user_name            => sm,
            :password             => 'sytw1234',
            :authentication       => 'plain',
            :enable_starttls_auto => true  }
      Mail.defaults do
	delivery_method :smtp, options
      end
	 
     mail=Mail.new do
       from sm
       to dir
       subject 'Bienvenido a Social Manager!'
       body 'Gracias por registarte en Social Manager'
     end
     
     mail.deliver!
   end
end
# http://127.0.0.1/auth/twitter/callback
# http://socialmanager.herokuapp.com/auth/twitter/callback
