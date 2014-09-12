#description.rb
require 'sinatra'
require 'sinatra/activerecord'
require '../config/environments'

class  Description < ActiveRecord::Base
  self.inheritance_column = nil
end
