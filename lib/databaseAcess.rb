#databaseAcess.rb

require_relative './models/website.rb'
require '../config/environments'
require 'sinatra/activerecord'


class DBAccess

	def initialize()

	end
   
   def pushToDB()

   	@website = Website.new(website_url: "http://gradresearch.unimelb.edu.au", website_name: "The Melbourne School Of Graduate Research - Home")
   	if  @website.save
   		 puts("saved")

   	else
   		puts ("error")
   	end

   	#respArray.each do |json|
   		#puts(json)
    end 


end