#page.rb
require 'sinatra'
require 'sinatra/activerecord'
require '../config/environments'

class  Page < ActiveRecord::Base
	has_many :categories
	belongs_to :report
end
