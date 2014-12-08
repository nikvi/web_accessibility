  #app.rb
  require 'sinatra/activerecord'
  require 'haml'
  require 'chartkick'
  require 'logger'
  require_relative 'lib/databaseAccess'
  require_relative 'lib/runReports'
  require_relative 'lib/jobs/report_job'



   #::Logger.class_eval { alias :write :'<<' }
    #access_log = ::File.join(::File.dirname(::File.expand_path(__FILE__)),'log','access.log')
    #access_logger = ::Logger.new(access_log)
    #error_logger = ::File.new(::File.join(::File.dirname(::File.expand_path(__FILE__)),'log','error.log'),"a+")

  configure do
    # logging is enabled by default in classic style applications,
    # so `enable :logging` is not needed
    #file = File.new("#{settings.root}/lib/log/#{settings.environment}.log", 'a+')
    #@file.sync = true
    #use Rack::CommonLogger,file
    #use ::Rack::CommonLogger, access_logger
    @@dataBase = DBAccess.new
  end

   before {
      env["rack.errors"] =  error_logger
    }  

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

  #method to retrieve all the requests for reports
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

  #submit  report request for a provided set of urls
  post '/urlCheck' do 
    @url    = params[:rurl] 
    @rpName = params[:rname]
    @rEmail = params[:rEmail]
    @p_urls = params[:rmessage]
    logger.warn("Submitted : " << @url)
    @@dataBase.persistURLS(@url,@rpName,@p_urls,@rEmail)
    haml :confirm_report
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

