# -*- coding: utf-8 -*-
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/reloader' if development?
require 'haml'
require 'omniauth-twitter'
require 'twitter'
require 'data_mapper'
require 'omniauth-oauth2'
require 'omniauth-google-oauth2'
require 'omniauth-facebook'
require 'linkedin'
require 'json'
require_relative 'helper/helpers.rb'

helpers AppHelpers

$message = {}

set :environment, :development

set :protection , :except => :session_hijacking

use OmniAuth::Builder do
  config = YAML.load_file 'config/config.yml'
  provider :google_oauth2, config['gidentifier'], config['gsecret'],
  {
     :authorize_params => {
        :force_login => 'false'
      }
    }
   provider :twitter, config['tidentifier'], config['tsecret'],
  {
     :authorize_params => {
        :force_login => 'false'
      }
    }
  provider :facebook, config['fidentifier'], config['fsecret'],
   {
    :scope => 'email, public_profile'
   }

end


#Configuracion DB

configure :development do

  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/social_manager.db" )
end

configure :production do
  DataMapper.setup(:default,ENV['HEROKU_POSTGRESQL_RED_URL'])
end


DataMapper::Logger.new($stdout, :debug)
DataMapper::Model.raise_on_save_failure = true

require_relative 'model'

DataMapper.finalize

# DataMapper.auto_migrate!
DataMapper.auto_upgrade!


enable :sessions
set :session_secret, '*&(^#234a)'

#Pagina de registro
get '/signup' do

  haml :signup

end

#Enviar datos de registro
post '/signup' do

  #Registro del usuario en la web, para rellenar los campos se podra hacer mediante oauth, esos datos recogidos se usaran para
  #crear el usuario de nuestra base de datos

  user = User.new
  user.name = params[:name]
  user.nickname = params[:nickname]
  user.password = params[:password]
  user.mail = params[:mail]

  content_type :json

  #Despues de recoger los datos comprobar que ese usuario no existe en la BBDD
  if User.count(:nickname => user.nickname) == 0
      user.save

    Thread.new do  #Ver si esto en Heroku funciona

      sendmail(params[:mail], params[:name],params[:nickname],params[:password])

    end

    session[:nickname] = params[:name]

    { :key1 => 'ok' }.to_json


  else

    { :key1 => 'error' }.to_json

  end

end


#Pagina bienvenida
get '/' do
   haml :signin
   #Login de nuestro usuario de la base de datos
end


#El usuario introduce los campos para ingresar en la app
post '/login' do

   nick = params[:nickname]
   pass = params[:password]
   user = User.first(:nickname => nick)
   content_type :json

   if(!user.is_a? NilClass)
     if(user.password == pass) then user_pass = user.password end
   end

   if (user.is_a? NilClass) #el usuario NO existe en la bbdd

     { :key1 => 'error1' }.to_json
   elsif (user_pass.is_a? NilClass) #la pass no coincide
     { :key1 => 'error2' }.to_json
   else
    session[:nickname] = nick
    { :key1 => 'ok' }.to_json

   end
end


get "/linkedin" do
   config = YAML.load_file 'config/config.yml'
   client = LinkedIn::Client.new(config['lidentifier'], config['lsecret'])
   user = User.first(:nickname => session[:nickname])
   lin = LinkedinData.new(:user => user)
   request_token = client.request_token(:oauth_callback => "http://#{request.host}:#{request.port}/auth/linkedin/callback")
   lin.rtoken = request_token.token
   lin.rsecret = request_token.secret
   lin.save
   redirect client.request_token.authorize_url
end


get '/auth/:name/callback' do
   config = YAML.load_file 'config/config.yml'
   auth = request.env['omniauth.auth']
#    puts "--> #{auth}"
   user = User.first(:nickname => session[:nickname])

   case params[:name] #nickname unico en nuestra app

   when 'twitter'
	  tweet = TwitterData.new(:user => user)
	  tweet.access_token = auth.credentials.token
	  tweet.access_token_secret = auth.credentials.secret
	  tweet.save
	  redirect '/user/index'

   when 'facebook'
 	  face = FacebookData.new(:user => user)
 	  face.token = auth.credentials.token
 	  face.save
# 	  FacebookData.first_or_create(:token => auth.credentials.token, :user => user)
      redirect '/user/index'

   when 'google_oauth2'
	  goo = GoogleData.new(:user => user)
	  goo.token = auth.credentials.token
	  goo.id_token = auth.extra.id_token
	  goo.save
	  redirect '/user/index'

   when 'linkedin'
	  client = LinkedIn::Client.new(config['lidentifier'], config['lsecret'])
	  lin = LinkedinData.first(:user => user)
	  if lin.atoken.nil?
		 pin = params[:oauth_verifier]
		 atoken, asecret = client.authorize_from_request(lin.rtoken, lin.rsecret, pin)
		 lin.atoken = atoken
		 lin.asecret = asecret
		 lin.save
	  end
	  redirect '/user/index'
   else
      redirect '/auth/failure'
    end
end


#Pagina principal del usuario
get '/user/:url' do
   if (session[:nickname] != nil)
	  config = YAML.load_file 'config/config.yml'
	  case(params[:url])
		 when "index"
			@user = session[:nickname]
			@message = []
			ruta = "https://github.com/alu0100207385/SocialManager/tree/master/public/img/"
			user = User.first(:nickname => @user)
			cuenta = FacebookData.first(:user => user)
			if (!cuenta.is_a? NilClass)
			   @F_on = true
# 			   @message << [ruta+"facebook_icon.png","[Facebook]",img,persona,comentario]
			else
			   @F_on = false
			end
			cuenta = GoogleData.first(:user => user)
			if (!cuenta.is_a? NilClass)
			   @G_on = true
# 			   @message << [ruta+"google_icon.png","[Google+]",img,persona,comentario]
			else
			   @G_on = false
			end
			cuenta = TwitterData.first(:user => user)
			if (!cuenta.is_a? NilClass)
			   @T_on = true
			   client = my_twitter_client(config['tidentifier'], config['tsecret'],cuenta.access_token,cuenta.access_token_secret)
			   persona = client.user_timeline(client.user.screen_name)
			   comentario = client.user_timeline(client.user.screen_name).first.text
			   img = client.user("AaronSocas").profile_image_url
#  			   @message << ["https://c3.datawrapper.de/T99EM/1/twitter-logo-50px.png","[Tweet]",img,"Aaron",comentario]
			   @message << [ruta+"twitter_icon.png","[Twitter]",img,persona,comentario]
			else
			   @T_on = false
			end
			cuenta = LinkedinData.first(:user => user)
			if (!cuenta.is_a? NilClass) and (!cuenta.atoken.is_a? NilClass)
			   @L_on = true
			   client = LinkedIn::Client.new(config['lidentifier'], config['lsecret'])
			   client.authorize_from_access(cuenta.atoken, cuenta.asecret)
			   l = client.network_updates
			   total = l.all.size
			   for n in 0...total
				  if l.all[n].is_commentable?
					 if l.all[n].update_comments.total > 0
						comentario = l.all[n].update_comments.all[0].comment
						persona = l.all[n].update_comments.all[0].person.first_name
						persona << " "+l.all[n].update_comments.all[0].person.last_name
						img =  l.all[n].update_comments.all[0].person.picture_url
						n = total
					 end
				  end
			   end
			   comentario = nil if self.is_a? NilClass
# 			   @message << ["https://pbs.twimg.com/profile_images/2945466711/12e018532d913494d841f79da5dd70bf_normal.png","[linkedin]",img,persona,comentario]
			   @message << [ruta+"linkedin_icon.png","[Linkedin]",img,persona,comentario]
			else
			   @L_on = false #No esta logueado o cancelo el proceso de vinculacion
			   if (!cuenta.is_a? NilClass)
				  cuenta.destroy #Borramos el registro incompleto (atoken y asecret estan vacios)
			   end
			end
			haml :index
		 when "settings"
			redirect '/settings'
	  end
   else
	  redirect '/'
   end
end


#Enviar un post desde la app a las redes sociales asociadas
post '/user/index' do

  content_type :json
   config = YAML.load_file 'config/config.yml'
   cad = params[:text]
   user = User.first(:nickname => session[:nickname])

   publico = params[:publico]

   if(publico == 'true') then $message = {:name => session[:nickname], :message => cad , :time => Time.now.asctime} end


#  Twitter
    if(params[:twitter] == 'true')
      puts 'twitter'
	  if (TwitterData.first(:user =>user) != nil)
      Thread.new do
		 t = TwitterData.first(:user =>user)
		 client = my_twitter_client(config['tidentifier'], config['tsecret'],t.access_token,t.access_token_secret)
		 client.update(cad[0,140])
      end
	  end
  end
# Linkedin
  if(params[:linkedin] == 'true')
    puts "linkedin"
	  if (LinkedinData.first(:user =>user) != nil)
		 lin = LinkedinData.first(:user =>user)
		 if !lin.atoken.nil?
      Thread.new do
			client = LinkedIn::Client.new(config['lidentifier'], config['lsecret'])
			client.authorize_from_access(lin.atoken, lin.asecret)
			client.add_share(:comment => cad)
      end

		 end
	  end
  end


    { :key1 => 'ok' }.to_json


end


#Desasociar una cuenta del usuario en la bbdd
get '/desvincular/:net' do
   user = User.first(:nickname => session[:nickname])
   case(params[:net])
   when "twitter"
	   cuenta = TwitterData.first(:user =>user)
	   cuenta.destroy
	   redirect '/user/index'
   when "facebook"
	  cuenta = FacebookData.first(:user =>user)
	  cuenta.destroy
	  redirect '/user/index'
   when "google"
	  cuenta = GoogleData.first(:user =>user)
	  cuenta.destroy
	  redirect '/user/index'
   when "linkedin"
	  cuenta = LinkedinData.first(:user =>user)
	  cuenta.destroy
	  redirect '/user/index'
   when "all"
	  nets = [TwitterData, FacebookData, GoogleData, LinkedinData]
	  nets.each do |n|
		 cuenta = n.first(:user =>user)
		 if (cuenta != nil) #Por si el usuario ha pulsado el boton y no todas estan asociadas
			cuenta.destroy
		 end
	  end
	  redirect '/settings'
   end
end


#Crea el link recuperacion de contraseña que sera enviado al email
post '/recuperarn' do
  user = User.first(:nickname => params[:nickname])

  if user!=nil
    generatedlink=createlink()
    l=LinkR.new(:link =>generatedlink, :user =>user)
    l.save
    Thread.new do
      sendrecoverymail(user.mail,user.name,user.nickname,generatedlink)
    end
  end
  redirect '/'
end

post '/recuperarm' do
  user = User.first(:mail => params[:mail])
  if user!=nil
    generatedlink=createlink()
    l=LinkR.new(:link =>generatedlink, :user =>user)
    l.save
    Thread.new do
      sendrecoverymail(user.mail,user.name,user.nickname,generatedlink)
    end
  end
  redirect '/'
end

#accedes a un link de recuperacion y lo buscas en la bd, si esta activo cargas la plantilla
get '/recovery/:net' do
  l=LinkR.first(:link=>params[:net])

  if (l!=nil)
    @user=l.user.nickname
    session[:usu]=@user
   haml :recoverylink
  else
   haml :recoveryfail
  end
end

post '/recovery' do
  user=User.first(:nickname=>session[:usu])
  user.password=params[:password]
  l=LinkR.first(:user=>user)
  user.save

  Thread.new do
    sendpasschange(user.mail,user.name,user.nickname,params[:password])
  end
  l.destroy

  redirect '/'
end


get '/recuperar' do
  haml :recovery
end

#Eliminar usuario y sus cuentas
get '/killuser' do
  user = User.first(:nickname => session[:nickname])
  f=FacebookData.first(:user => user)
  g=GoogleData.first(:user => user)
  t=TwitterData.first(:user => user)

  if (f.is_a? FacebookData)
    f.destroy
  end
  if (g.is_a? GoogleData)
    g.destroy
  end

  if (t.is_a? TwitterData)
    t.destroy
  end

  user.destroy
  session.clear
  redirect '/'
end


#Opciones de configuracion del usuario
get '/settings' do
   if (session[:nickname] != nil)
	  @user = session[:nickname]
	  @user = User.first(:nickname => @user)
	  @asociadas = []
	  f_on = FacebookData.first(:user => @user) #Para marcar en la vista las casillas en las que el user esta logueado
	  if (!f_on.is_a? NilClass)
		 @asociadas << "Facebook"
	  end
	  g_on = GoogleData.first(:user => @user)
	  if (!g_on.is_a? NilClass)
		 @asociadas << "Google"
	  end
	  t_on = TwitterData.first(:user => @user)
	  if (!t_on.is_a? NilClass)
		 @asociadas << "Twitter"
	  end
	  l_on = LinkedinData.first(:user => @user)
	  if (!l_on.is_a? NilClass) and (!l_on.atoken.is_a? NilClass)
		 @asociadas << "Linkedin"
	  end
	  #Eliminar cuenta de nuestra app
	  haml :settings
   else
	  redirect '/'
   end
end

get '/event' do

  content_type "text/event-stream"
  stream(:keep_open) do |out|


    trace_var(:$message) {|value| out << "data: #{value.to_json} \n\n"}


  end



end


#Pagina de ayuda
get '/help' do
   haml :help
end


get '/support' do
   haml :support
end


#Salir de la app
get '/logout' do
   session.clear
   redirect '/'
end


#Cualquier error de ruta debe ser redireccionada aqui
get '/auth/failure' do
  flash[:notice] =
    %Q{<h3>Se ha producido un error en la autenticacion</h3> &#60; <a href="/user/index">Volver</a> }
end
