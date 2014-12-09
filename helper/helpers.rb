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

   def sendmail(mail,name,username,pass)
     sm = 'social.manager.info@gmail.com'

     options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'localhost', #Cambiar el dominio por socialmanager.herokuapp.com Cuando se suba a heroku
            :user_name            => sm,
            :password             => 'sytw1234',
            :authentication       => 'plain',
            :enable_starttls_auto => true  }
      Mail.defaults do
	       delivery_method :smtp, options
      end

    Mail.deliver do

       to mail
       from sm
       subject "Bienvenido a Social Manager #{name}!"
       body %Q|Gracias por registrarte en Social Manager

                Tu usuario es: #{username}
		            Tu contraseña es: #{pass}

                Disfruta de tu experiencia con nosotros. |
     end
   end
end
# http://127.0.0.1/auth/twitter/callback
# http://socialmanager.herokuapp.com/auth/twitter/callback
