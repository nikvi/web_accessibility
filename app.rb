#app.rb
require 'sinatra/activerecord'
require 'haml'
require 'chartkick'
require_relative 'lib/databaseAccess'


configure do
  # logging is enabled by default in classic style applications,
  # so `enable :logging` is not needed
  file = File.new("#{settings.root}/lib/log/#{settings.environment}.log", 'a+')
  file.sync = true
  @@dataBase = DBAccess.new
  use Rack::CommonLogger, file
end

#home page of the application
get '/' do 
  redirect to('/reportsGen')
end 
  

get '/deleteReport/:id/:name' do |id,name|
  haml :confirm, :locals => { :name => name, :id => id}
end

#the delete code is currently commented out
delete '/:id' do
  @@dataBase.delete_report(params[:id])
  redirect to('/reportsGen')
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
  @report_error = report["errors"]
  haml :reportDetail 
end 


get '/reportsGen' do
  reports = @@dataBase.getAllReports() 
  @web_array = reports["rep_data"]
  @@web_summary = reports["rep_errors"]
  haml :reportsGen 
end 

