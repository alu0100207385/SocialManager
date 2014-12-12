# -*- coding: utf-8 -*-
require 'coveralls'
Coveralls.wear!

require_relative '../app.rb'
ENV['RACK_ENV'] = 'test'
require 'rack/test'
require 'rubygems'
require 'rspec'

include Rack::Test::Methods

describe "Test App: Get Methods" do

  def app
    Sinatra::Application
  end

   it "Access to root" do
	  get '/' 
	  expect(last_response).to be_ok
   end

   it "Access to signup page" do
	  get '/signup'
	  expect(last_response).to be_ok
   end
   
   it "Access to recovery page" do
	  get '/recuperar'
	  expect(last_response).to be_ok
   end
   
   it "Access to help page" do
	  get '/help'
	  expect(last_response).to be_ok
   end
   
   it "Access to failure page" do
	  get '/auth/failure'
	  expect(last_response).to be_ok
   end  
end
