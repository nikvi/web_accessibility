#website.rb
require 'sinatra'
require 'sinatra/activerecord'
require '../config/environments'
class Website < ActiveRecord::Base
	has_many :reports
end