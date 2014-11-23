# -*- coding: utf-8 -*-
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/reloader' if development?
require 'haml'


get '/' do
   haml :signin
end

get '/index' do
   haml :index
end

get '/help' do
   haml :help
end

get '/auth/failure' do
  flash[:notice] =
    %Q{<h3>Se ha producido un error en la autenticacion</h3> &#60; <a href="/">Volver</a> }
end