#report.rb
require 'sinatra'
require 'sinatra/activerecord'


class  Report < ActiveRecord::Base
	has_many :pages, :dependent => :destroy
	belongs_to :website
end
