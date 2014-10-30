#page.rb
require 'sinatra'
require 'sinatra/activerecord'

class  Page < ActiveRecord::Base
	has_many :categories, :dependent => :destroy
	belongs_to :report
end
