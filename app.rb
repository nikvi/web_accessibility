  #app.rb
  require 'sinatra/activerecord'
  require 'haml'
  require 'chartkick'
  require 'logger'
  require_relative 'lib/databaseAccess'
  require_relative 'lib/runReports'
  require_relative 'lib/jobs/report_job'
  Dir.glob('./config/initializers/*.rb', &method(:require))


   #::Logger.class_eval { alias :write :'<<' }
    #access_log = ::File.join(::File.dirname(::File.expand_path(__FILE__)),'log','access.log')
    #access_logger = ::Logger.new(access_log)
    #error_logger = ::File.new(::File.join(::File.dirname(::File.expand_path(__FILE__)),'log','error.log'),"a+")

  configure do
    @@dataBase = DBAccess.new
  end

   #before {
     # env["rack.errors"] =  error_logger
    #}  

  #home page of the application
  get '/' do 
    redirect to('/reportsGen')
  end 
    
  #show confrimation page for deletion of report 
  get '/deleteReport/:id/:name' do |id,name|
    haml :confirm, :locals => { :name => name, :id => id}
  end

  # shown when rerun request is submitted
  get '/rerunReport/:id' do
    @@dataBase.rerunReport(params[:id])
    haml :confirm_report
  end

  #the delete code is currently commented out
  delete '/:id' do
    @@dataBase.delete_report(params[:id])
    redirect to('/reportsGen')
  end


  # intial form submit page where you provide the report requests
  get '/urlCheck' do 
    logger.warn(" in URL submit page")
    haml :submitURL 
  end 

  #method to retrieve all the requests for reports to be run
  get '/requestedReports'  do
   @report_req = @@dataBase.getReportRequests()
   haml :reportRun
  end

  #creates a worker thread and runs the report asynchrnously
  #updates status to running
  get '/requestedReports/:id' do |id|
    ReportJob.new.async.perform(id)
    @@dataBase.updateReqReportStatus(id)
    redirect to('/requestedReports')
  end

  #submits report request for a provided set of urls 
  post '/urlCheck' do 
    @url   = params[:rurl]
    @p_urls = params[:rmessage]
    #remove spaces
    @p_urls.strip!
    logger.warn("Submitted : " << @url)
    @@dataBase.persistURLS(@url,params[:rname],@p_urls,params[:rEmail])
    haml :confirm_report
  end

  #gets information about the specified report
  get '/reportDetail/:id/:name' do |id,name|
    report           = @@dataBase.getReportDetails(id)
    @tot_data        = Hash[@@web_summary.sort]
    @report_det      = report["pg_data"]
    @report_sum      = report["summary"]
    @timeline_data   = report["rprts_timeline"]
    @report_err      = get_hash_diff(report["errors"],@tot_data)
    haml :reportDetail,:locals => { :name => name ,:id => id}
  end 

  #used to display the pie chart for the specific report
  #add the extra keys from report_smmary and provide value of zero
  #that ensures the same colors in both pie charts reflect the same error type
  def get_hash_diff(report_data,overall_data)
    overall_data.each_key { |key| 
      report_data[key] = 0 unless report_data.has_key?(key)
    }
    return Hash[report_data.sort]
  end

 #used to retrieve and display all reports
  get '/reportsGen' do
    reports       = @@dataBase.getAllReports()
    @web_array    = reports["rep_data"]
    @@web_summary = reports["rep_errors"]
    @@err_avg   = reports["site_err_average"]
    haml :reportsGen 
  end



