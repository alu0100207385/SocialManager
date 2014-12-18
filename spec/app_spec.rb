# -*- coding: utf-8 -*-
require 'coveralls'
Coveralls.wear!

require_relative '../app.rb'
require_relative '../helper/helpers.rb'
ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require 'rubygems'
require 'rspec'
require 'test/unit'
# require 'rspec/expectations'
require 'selenium-webdriver'

include Rack::Test::Methods
include Test::Unit::Assertions
include AppHelpers

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
   
   it "Access to recovery page" do
	  get '/recuperar'
	  expect(last_response).to be_ok
   end
   
   it "Access support page" do
	  get '/support'
	  expect(last_response).to be_ok
   end

   it "No Log in: no access settings page" do
	  get '/settings'
	  expect(last_response.body).to eq("")
   end

   it "No Log in: no access user/index" do
	  get '/user/index'
	  expect(last_response.body).to eq("")
   end
   
   it "No Log in: no access event" do
	  get '/event'
	  expect(last_response.body).to eq("")
   end
   
   it "Check Twitter Client" do
	  client = my_twitter_client('1','2','3','4')
	  assert_equal(Twitter::REST::Client,client.class)
   end
   
   it "Load params" do
	  cad = loadparams
	  assert_equal(cad,"social.manager.info@gmail.com")
   end
   
   it "Check send mail" do
	  assert_equal(Mail::Message,sendmail("usu0100@gmail.com","usuario","de prueba","1234").class)
   end
   
   it "Check recovery pass by mail" do
	  assert_equal(Mail::Message,sendrecoverymail("usu0100@gmail.com","usuario","de prueba","1234").class)
   end
   
   it "Check change by mail" do
	  assert_equal(Mail::Message,sendpasschange("usu0100@gmail.com","usuario","de prueba","1234").class)
   end
   
   it "Check trashmail" do
	  assert_equal(Mail::Message,trashmail("usuario","usu0100@gmail.com","pruebas").class)
   end
   
   it "Check create link" do
	  link = createlink
	  assert_equal(String,link.class)
   end

   it "Check post from signup" do
	  post '/signup', :nickname => "nuevo", :password => "1234"
	  expect(last_response).to be_ok
   end
   
   it "Check login fail" do
	  post '/login'
	  expect(last_response).to be_ok
   end
   
   it "Check access return class linkedin oauth" do
	  resul = get '/linkedin'
	  assert_equal(Rack::MockResponse, resul.class)
   end
   
   it "Check access return class twitter oauth" do
	  resul = get '/auth/twitter/callback'
	  assert_equal(Rack::MockResponse, resul.class)
   end
   
#       it "Podemos enviar: post" do
# 	  post '/login' , :nick => "Usuario"
# 	  expect(last_response).to be_ok
#    end
# 	  expect(last_response.body).to eq("{\"key1\":\"error1\"}")
# 	  expect(last_response.body).to eq("Not an ajax request")
end
