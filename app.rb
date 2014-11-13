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
  @rName = params[:rName]
  logger.warn("Submitted : " << @url)
  @@dataBase.persistURLS(@url,@rName)
  haml :submitURL 
end 

get '/reportDetail/:id/:name' do |id,name|
  report      = @@dataBase.getReportDetails(id)
  @tot_data   = Hash[@@web_summary.sort]
  @report_det = report["pg_data"]
  @report_sum = report["summary"]
  @report_err = get_hash_diff(report["errors"],@tot_data)
  haml :reportDetail,:locals => { :name => name}
end 

# add the extra keys from report_smmary and provide value of zero
def get_hash_diff(report_data,overall_data)
  overall_data.each_key { |key| 
    report_data[key] = 0 unless report_data.has_key?(key)
  }
  return Hash[report_data.sort]
end


get '/reportsGen' do
  reports = @@dataBase.getAllReports() 
  @web_array = reports["rep_data"]
  @@web_summary = reports["rep_errors"]
  haml :reportsGen 
end 

