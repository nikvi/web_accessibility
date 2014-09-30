#website.rb
require 'sinatra'
require 'sinatra/activerecord'

class Website < ActiveRecord::Base
	has_many :reports
end