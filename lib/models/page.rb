#page.rb
require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'

class  Page < ActiveRecord::Base
end