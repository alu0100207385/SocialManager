# -*- coding: utf-8 -*-
require 'coveralls'
Coveralls.wear!

require_relative '../app.rb'
ENV['RACK_ENV'] = 'test'
require 'rack/test'
require 'test/unit'
require 'minitest/autorun'
require 'rubygems'
require 'rspec'
require 'rspec/expectations'

include Rack::Test::Methods

describe "Managing users accounts" do
   before :all do
	  @user="usu0100"
	  @email="social.manager.info@gmail.com"
	  @pass="1234"
   end
   
   it "Register user" do
    u = User.new    
    u.name = @user
    u.nickname = @user
    u.password = @pass
    u.mail = @email
    
    expect(u.save).to be true
 
   end
   
   it "Delete user" do
     u=User.first(:nickname => @user)
     expect(u.destroy).to be true
   end
  
end

describe " " do
  
end