# -*- coding: utf-8 -*-
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/reloader' if development?
require 'haml'
require 'omniauth-twitter'
require 'data_mapper'
require 'omniauth-oauth2'
require 'omniauth-google-oauth2'
require 'omniauth-facebook'

set :environment, :development

set :protection , :except => :session_hijacking

use OmniAuth::Builder do
  config = YAML.load_file 'config/config.yml'
  provider :google_oauth2, config['gidentifier'], config['gsecret'],
  {
     :authorize_params => {
        :force_login => 'true'
      }
    }
	provider :twitter, config['tidentifier'], config['tsecret'],
  {
     :authorize_params => {
        :force_login => 'true'
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

use Rack::MethodOverride

Base = 36

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
  
  #Despues de recoger los datos comprobar que ese usuario no existe en la BBDD
  if User.count(:nickname => user.nickname) == 0
      user.save
	  puts "Usuario creado con exito"
	  redirect '/' ##Considerar redirigirlo a user/index

  else
      puts 'nope'
  end

end

#Pagina bienvenida
get '/' do
   haml :signin
   #Login de nuestro usuario de la base de datos
end

#El usuario introduce los campos para ingresar en la app
post '/login' do
   @control = 0
   nick = params[:nickname]
   pass = params[:password]
   user = User.first(:nickname => nick)
   user_pass = User.first(:password => pass)
   if (user.is_a? NilClass) #el usuario NO existe en la bbdd
	  @control = 1;
	  haml :signin
   elsif (user_pass.is_a? NilClass) #la pass no coincide
	  @control = 2;
	  haml :signin
   else
	  redirect '/user/index'
   end
end


get '/auth/:name/callback' do
    config = YAML.load_file 'config/config.yml'
    case params[:name]
    when 'google_oauth2'
      @auth = request.env['omniauth.auth']
      session[:name] = @auth['info'].name
      session[:email] = @auth['info'].email
#     session[:image] = @auth['info'].image
      redirect "user/index"

    when 'facebook'
      @auth = request.env['omniauth.auth']
      session[:name] = @auth['info'].name
#       puts "#{session[:name]}"
      session[:nickname] = @auth['info'].nickname
#       puts "#{session[:nickname]}"
      redirect "/index"
    else
      redirect "/auth/failure"
    end
end


get '/user/:url' do
   if (session[:nickname] != nil)
	  case(params[:url])
		 when "index"
			@user = session[:nickname]
			haml :index
	  end
   else
	  redirect '/'
   end
end

#Enviar un post desde la app a las redes sociales asociadas
post '/index' do
  
end

#Pagina de ayuda
get '/help' do
   haml :help
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