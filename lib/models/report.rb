#report.rb
require 'sinatra'
require 'sinatra/activerecord'
require '../config/environments'

class  Report < ActiveRecord::Base
	has_many :pages
	belongs_to :website
end
