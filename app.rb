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
require 'json'

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
    :scope => 'email, public_profile', :auth_type => 'reauthenticate'

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

#DataMapper.auto_migrate!
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
  user.mail = params[:email]

  #Despues de recoger los datos comprobar que ese usuario no existe en la BBDD
  if User.count(:nickname => user.nickname) == 0
      user.save
      erb <<-'HTML', :layout => false
        <p class="bg-success">Usuario Creado con exito </p>
        HTML
  else
    erb <<-'HTML', :layout => false
    <p class="bg-danger">El usuario ya existe, por favor utiliza otro nickname. </p>
    HTML
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
   case params[:name] #nickname unico en nuestra app

   when 'twitter'
	  @auth = request.env['omniauth.auth']
# 	  puts "---------------#{@auth}"
	  user = User.first(:nickname => session[:nickname])
	  tweet = TwitterData.new(:user => user)
# 	  tweet.name = @auth['info'].name
	  tweet.access_token = @auth.credentials.token
	  tweet.access_token_secret = @auth.credentials.secret
	  tweet.save
# 	  property  :id, Serial
	  redirect '/user/index'
=begin
   when 'google_oauth2'
	  @auth = request.env['omniauth.auth']
	  session[:name] = @auth['info'].name
	  session[:email] = @auth['info'].email
	  redirect "user/index"

    when 'facebook'
      @auth = request.env['omniauth.auth']
      session[:name] = @auth['info'].name
#       puts "#{session[:name]}"
      session[:nickname] = @auth['info'].nickname
#       puts "#{session[:nickname]}"
      redirect "/index"
=end
    else
      redirect "/auth/failure"
    end
end

#Pagina principal del usuario
get '/user/:url' do 
   if (session[:nickname] != nil)
	  case(params[:url])
		 when "index"
			@user = session[:nickname]
			user = User.first(:nickname => @user)
			@F_on = FacebookData.first(:id => user.id) #Para marcar en la vista las casillas en las que el user esta logueado
			@G_on = GoogleData.first(:id => user.id)
			@T_on = TwitterData.first(:id => user.id)
			haml :index
	  end
   else
	  redirect '/'
   end
end

#Enviar un post desde la app a las redes sociales asociadas
post '/user/index' do
# Twitter
#    client = my_twitter_client()
#    client.update("cadena")

# Facebook

# Google+

end

#Desasociar una cuenta del usuario en la bbdd
get '/desvincular/:net' do
   case(params[:net])
   when "twitter"
	   user = User.first(:nickname => session[:nickname])
	   cuentaT=TwitterData.first(:user =>user)
	   cuentaT.destroy
	   redirect '/user/index'
   when "facebook"
	  user = User.first(:nickname => session[:nickname])
	  cuentaT=FacebookData.first(:user =>user)
	  cuentaT.destroy
	  redirect '/user/index'
   when "google"
	  user = User.first(:nickname => session[:nickname])
	  cuentaT=GoogleData.first(:user =>user)
	  cuentaT.destroy
	  redirect '/user/index'
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
    %Q{<h3>Se ha producido un error en la autenticacion</h3> &#60; <a href="/">Volver</a> }
end
