#app.rb
require 'sinatra'
require 'sinatra/activerecord'
require 'haml'
require_relative './databaseAccess'


configure do
  # logging is enabled by default in classic style applications,
  # so `enable :logging` is not needed
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  @@dataBase = DBAccess.new
  use Rack::CommonLogger, file
end

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
  logger.warn(" in URL submit page")
  haml :submitURL 
end 


post '/urlCheck' do 
  @url = params[:url] 
  logger.warn("Submitted : " << @url)
  @@dataBase.persistURLS(@url)
  haml :submitURL 
end 

get '/reportDetail/:id/:name' do |id,name|
  @name = name
  report = @@dataBase.getReportDetails(id)
  @report_det = report["pg_data"]
  @report_sum = report["summary"]
  haml :reportDetail 
end 


get '/reportsGen' do 
  @web_array = @@dataBase.getAllReports()
  haml :reportsGen 
end 

