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
	  @site = 'http://localhost:4567/'
	  @browser.get(@site)
	  @browser.manage().window().maximize()
	  @browser.manage.timeouts.implicit_wait = 5
   end

   after :all do
	  @browser.quit
   end
end