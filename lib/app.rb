#app.rb
require 'sinatra'
require 'sinatra/activerecord'
require 'haml'
require_relative './databaseAccess'

#home page of the application
get '/' do 
  haml :index 
end 
  
# This one shows how you can use refer to 
# variables in your Haml views. 
# This method uses member variables. 
get '/hello/:name' do|name| 
  @name = name 
  haml :hello 
end 
  
# This method shows you how to inject 
# local variables 
get '/goodbye/:name' do|name| 
  haml :goodbye, :locals => { :name => name } 
end 


# form submit page to get the url
get '/urlCheck' do 
  haml :submitURL 
end 


post '/urlCheck' do 
  @url = params[:url] 
  haml :submitURL 
end 



# traceroute 
get '/reportsGen' do 
  dataB = DBAccess.new
  @web_array = dataB.getAllReports()
  haml :reportsGen 
end 