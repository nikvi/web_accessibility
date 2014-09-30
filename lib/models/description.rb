#description.rb
require 'sinatra'
require 'sinatra/activerecord'


class  Description < ActiveRecord::Base
  self.inheritance_column = nil
end
