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
require 'omniauth-linkedin'
require 'linkedin'
require 'json'
require_relative 'helper/helpers.rb'

helpers AppHelpers

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
  provider :linkedin, config['lidentifier'], config['lsecret']

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
	  lin = LinkedinData.new(:user => user)
# 	  token = auth.credentials.token
# 	  secret = auth.credentials.secret
	client = LinkedIn::Client.new(config['lidentifier'], config['lsecret'])
	request_token = client.request_token({}, :scope => "rw_nus")
	rtoken = request_token.token
	rsecret = request_token.secret
	pin = params[:oauth_verifier]
	lin.atoken, lin.asecret = client.authorize_from_request(rtoken, rsecret, pin)
	  lin.save
	  redirect '/user/index'

    else
      redirect '/auth/failure'
    end
end

#Pagina principal del usuario
get '/user/:url' do
   if (session[:nickname] != nil)
	  case(params[:url])
		 when "index"
			@user = session[:nickname]
			user = User.first(:nickname => @user)
			@F_on = FacebookData.first(:user => user) #Para marcar en la vista las casillas en las que el user esta logueado
			@G_on = GoogleData.first(:user => user)
			@T_on = TwitterData.first(:user => user)
			@L_on = LinkedinData.first(:user => user)
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
   config = YAML.load_file 'config/config.yml'
   cad = params[:text]
#    puts "---#{cad}"
   user = User.first(:nickname => session[:nickname])
   @enviado = false

   if ( cad != "")

#  Twitter
	  if (TwitterData.first(:user =>user) != nil)
		 t = TwitterData.first(:user =>user)
		 client = my_twitter_client(config['tidentifier'], config['tsecret'],t.access_token,t.access_token_secret)
		 client.update(cad[0,140])
		 @enviado = true
	  end

# Linkedin
	  if (LinkedinData.first(:user =>user) != nil)
		 l = LinkedinData.first(:user =>user)
		 client = LinkedIn::Client.new(config['lidentifier'], config['lsecret'])
# 		 request_token = client.request_token({}, :scope => "rw_nus")
# 		 rtoken = request_token.token
# 		 rsecret = request_token.secret
# 		 pin = params[:oauth_verifier]
# 		 puts "PIN = #{pin}"
# 		 atoken, asecret = client.authorize_from_request(rtoken, rsecret, pin)
		 client.authorize_from_access(l.atoken, l.asecret)
		 client.add_share(:comment => cad)
		 @enviado = true
	  end

# Facebook

# Google+
	  redirect '/user/index'
   end

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
   #Modificar perfil
   #Desvincular cuentas
   @user = session[:nickname]
   @user = User.first(:nickname => @user)
   @asociadas = []
   @F_on = FacebookData.first(:user => @user) #Para marcar en la vista las casillas en las que el user esta logueado
   if @F_on != nil
	  @asociadas << "Facebook"
   end
   @G_on = GoogleData.first(:user => @user)
   if @G_on != nil
	  @asociadas << "Google"
   end
   @T_on = TwitterData.first(:user => @user)
   if @T_on != nil
	  @asociadas << "Twitter"
   end
   @L_on = LinkedinData.first(:user => @user)
   if @L_on != nil
	  @asociadas << "Linkedin"
   end
   #Eliminar cuenta de nuestra app
   haml :settings
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
