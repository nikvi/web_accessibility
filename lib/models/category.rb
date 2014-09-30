#category.rb
require 'sinatra'
require 'sinatra/activerecord'


class  Category < ActiveRecord::Base
	belongs_to :page
end
