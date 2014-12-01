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

post '/signup' do

  #Registro del usuario en la web, para rellenar los campos se podra hacer mediante oauth, esos datos recogidos se usaran para
  #crear el usuario de nuestra base de datos
  
  user = User.new
  user.name = params[:name]
  user.nickname = params[:nickname]
  user.password = params[:password]
  user.mail = params[:mail]
  
  
  if User.count(:nickname => user.nickname) == 0
      user.save

  else
      puts 'nope'
  end

end

#Pagina bienvenida
get '/' do
   haml :signin
   #Login de nuestro usuario de la base de datos
end

post '/login' do
   nick = params[:nickname]
   pass = params[:password]
   user = User.first(:nickname => nick)
   puts "---------------#{user.class}"
   if (user.is_a? NilClass) #el usuario NO existe en la bbdd
	  @control = 1;
	  redirect '/'
   else
	  redirect '/index'
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


get '/index' do
#    /index/:user
   haml :index
end

post '/index' do
  
end

get '/help' do
   haml :help
end

get '/logout' do
   session.clear
   redirect '/'
end

get '/auth/failure' do
  flash[:notice] =
    %Q{<h3>Se ha producido un error en la autenticacion</h3> &#60; <a href="/">Volver</a> }
end