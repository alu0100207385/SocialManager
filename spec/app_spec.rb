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
   
   it "Check create link" do
	  link = createlink
	  assert_equal(String,link.class)
   end
   
   it "Check login fail" do
	  post '/login'
	  expect(last_response.body).to eq("{\"key1\":\"error1\"}")
   end
   
#    it "Check linkedin access" do
# 	  get '/linkedin'
# 	  expect(last_response.body).to eq("Not an ajax request")
# 	  expect(last_response).to be_ok
#    end
end

=begin
describe "Test Chat App: Check pages and links" do
   
   before :all do
	  @browser = Selenium::WebDriver.for :firefox
	  @site = 'http://localhost:9292/'
	  @browser.get(@site)
	  @browser.manage().window().maximize()
	  @browser.manage.timeouts.implicit_wait = 5
   end

   after :all do
	  @browser.quit
   end

   it "##1. I can access index page" do
	  expect(@site).to eq(@browser.current_url)
   end

   it "##2. I can see index page" do
	  element = @browser.find_element(:tag_name,"h1").text
	  expect("Welcome to Social Manager").to eq(element)
   end
end
=end