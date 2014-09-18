#category.rb
require 'sinatra'
require 'sinatra/activerecord'
require '../config/environments'

class  Category < ActiveRecord::Base
	belongs_to :page
end
