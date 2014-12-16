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


describe "Test Chat App: Comprobacion de paginas y enlaces" do
   
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
   
   it "##9. I can access Icon Google Plus" do
	  @browser.find_element(:id,"gplus").click
	  @browser.manage.timeouts.implicit_wait = 3
	  element = @browser.find_element(:id,"link-signup").text
	  if(element.include?("Crear una cuenta")==true) or (element.include?("Create an account") ==true)
	  	 control= true
	  else
	  	control = false
	  end
	  assert_equal(true,control)
   end

   it "##10. I can access Icon Facebook" do
	  @browser.find_element(:id,"fb").click
	  @browser.manage.timeouts.implicit_wait = 3
	  assert_equal("https://www.facebook.com/", @browser.current_url)
   end

   it "##11. I can access Icon Twitter" do
	  @browser.find_element(:id,"tw1").click
	  @browser.manage.timeouts.implicit_wait = 3
	  assert_equal("https://twitter.com/", @browser.current_url)
   end

   it "##12. I can access Icon Github" do
	  @browser.find_element(:id,"gh1").click
	  @browser.manage.timeouts.implicit_wait = 3
	  assert_equal("https://github.com/alu0100207385/SocialManager", @browser.current_url)
   end
end
