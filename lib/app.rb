#app.rb
require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'

class Website < ActiveRecord::Base
end




get '/' do
    "Hello, World!"
end