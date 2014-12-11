module AppHelpers

  require 'mail'
  require 'bcrypt'

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
   
   def loadparams()
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
      return sm
   end

   def sendmail(mail,name,username,pass)
    sm=loadparams()

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
   
   def sendrecoverymail(mail,name,username,link)
     sm=loadparams()
     
     Mail.deliver do
       to mail
       from sm
       subject "Social Manager: Recuperacion de contraseña #{name}!"
       body %Q|Has perdido o olvidado tu contraseña...
	       No hay problema! Clickea en link que te ofrecemos a continuacion y podras volvera a cambiar tu contraseña.

                Tu usuario es: #{username}
		Link re recuperacion: /recovery/#{link}

                Disfruta de tu experiencia con nosotros. |
     end    
   end
   
   def createlink()
      #link="http://socialmanager.herokuapp.com/" + BCrypt::Password.create(rand(10000000000000)).to_s.slice(20,8)
    link= BCrypt::Password.create(rand(10000000000000)).to_s.slice(20,8)
    return link
   end
end
# http://127.0.0.1/auth/twitter/callback
# http://socialmanager.herokuapp.com/auth/twitter/callback
