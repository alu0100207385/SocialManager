# -*- coding: utf-8 -*-
require_relative '../app.rb'
require 'test/unit'
require 'minitest/autorun'
require 'rack/test'
require 'selenium-webdriver'
require 'rubygems'

include Rack::Test::Methods

def app
   Sinatra::Application
end


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
	  assert_equal(@site, @browser.current_url)
   end

   it "##2. I can see index page" do
	  element = @browser.find_element(:tag_name,"h1").text
	  assert_equal("Welcome to Social Manager", element)
   end

   it "##3. I can access Jazer's page" do
	  @browser.find_element(:id,"jz").click
	  @browser.manage.timeouts.implicit_wait = 3
	  assert_equal("https://github.com/alu0100595727", @browser.current_url)
   end
   
   it "##4. I can access Javier's page" do
	  @browser.find_element(:id,"jc").click
	  @browser.manage.timeouts.implicit_wait = 3
	  assert_equal("https://github.com/alu0100505023", @browser.current_url)
   end
   
   it "##5. I can access AaronS's page" do
	  @browser.find_element(:id,"aa1").click
	  @browser.manage.timeouts.implicit_wait = 3
	  assert_equal("http://alu0100207385.github.io/", @browser.current_url)
   end

   it "##6. I can access AaronV's page" do
	  @browser.find_element(:id,"aa2").click
	  @browser.manage.timeouts.implicit_wait = 3
	  assert_equal("https://github.com/alu0100537451", @browser.current_url)
   end

   it "##7. I can access Repository page" do
	  @browser.find_element(:id,"repo").click
	  @browser.manage.timeouts.implicit_wait = 3
	  assert_equal("https://github.com/alu0100207385/SocialManager", @browser.current_url)
   end
   
   it "##8. I can access Help page" do
	  @browser.find_element(:id,"help").click
	  @browser.manage.timeouts.implicit_wait = 3
	  assert_equal(@site+"help", @browser.current_url)
   end
   
   it "##9. I can access Recovery page" do
	  @browser.find_element(:id,"recovery").click
	  @browser.manage.timeouts.implicit_wait = 3
	  assert_equal(@site+"recuperar", @browser.current_url)
   end
   
#    it "##10. I can access Registration page" do
#    it "##11. I can access Registration page and come back" do
   
end

describe "Test Chat App: Sign in page: Log&Reg" do
   
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
   
   it "##1. User not exist" do
	  @browser.find_element(:id,"nickname").send_keys("someone")
	  @browser.find_element(:id,"password").send_keys("1234")
	  @browser.find_element(:id,"login").click
	  @browser.manage.timeouts.implicit_wait = 5
	  element = @browser.find_element(:id,"text").text
	  assert_equal("The user does not exist in the database.",element)
   end

   it "##2. Registation Fail" do
	  @browser.find_element(:id,"reg").click
	  @browser.manage.timeouts.implicit_wait = 5
	  @browser.find_element(:id,"Registrarse").click
	  @browser.manage.timeouts.implicit_wait = 5
	  element = @browser.find_element(:id,"text").text
	  assert_equal("Error, missing a field filled.",element)
   end
end
=begin
   it "##3. Registation Ok" do
   end
   
   it "##4. Log out" do
   end
   
   it "##5. Log in Ok" do
   end

end

# describe "Test Chat App: User's actions" do
#    Postear, entrar a opciones, leer
# end
=end   