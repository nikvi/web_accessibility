#submitUrl.rb

require 'sinatra'
require 'sinatra/activerecord'

class Submit < ActiveRecord::Base
	has_many :reports,:dependent => :destroy
end