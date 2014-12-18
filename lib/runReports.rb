# runReports.rb
require './config/waveApiConfig'
require 'pony'
require_relative './parseCsv.rb'
require_relative './databaseAccess.rb'
require_relative './queryWave.rb'
require_relative  './models/submit.rb'


class RunReports
	# generates the formatted url used to access Wave
	def format_url_data(data)
		query_urls = Array.new
		data["array"].each do |x| 
	    	str = "#{WaveConfig::WAVE_API_URL}key=#{ENV['WAVE_API_KEY']}&url=#{x}&reporttype=#{WaveConfig::REPORT_TYPE}" 
	    	puts str
	    	query_urls.push str
	  	end
		return {"urls" => query_urls, "name" => data["rep_name"], "submit_id" => data["submit_id"] }
	end

	def run_reports_csv(file_name,source,url_count=5)
		qv = QueryWaveAPI.new
		parser  = ParseCSV.new(file_name,source)
		data    = parser.get_urls(url_count)
	    qv.query_wave(format_url_data(data))
	end

	#def run_reports_web()
		#db          = DBAccess.new()
		#report_data = db.get_requested_urls()
		#report_data.each do |dt|
		#	@qv.query_wave(format_url_data(dt))
	  	#end	
	#end

	def run_report_db(rep_id)
		ActiveRecord::Base.transaction do
			 qv  = QueryWaveAPI.new
			 rep = Submit.find(rep_id)
			 @report_req  = {
			 "submit_id"  => rep.id,
		      "rep_name"  => rep.report_name,
		      "email_id"  => rep.email_id,
		      "array"     => (rep.pg_urls).split(',')
		    }
		    begin
			    qv.query_wave(format_url_data(@report_req))
			    sendMail(@report_req,'success')
			    rep.update_attributes(report_run_status: 'complete')
			rescue => error
				puts "failed with error: " << error
				sendMail(@report_req,'fail')
				rep.update_attributes(report_run_status: 'failed')
				#should delete from table?? (what if update fails???)
			end
		end
	end

	def sendMail(report_req,status)
		begin
		 case status
		 when 'success'
			Pony.mail(:to => report_req["email_id"], :subject => "Web Accessiblity Report: #{report_req["rep_name"]} ", 
				   :body => "The accessiblity report for #{@report_req["rep_name"]} has been generated.", :from => 'web_accessiblity@unimelb.edu.au')
	     when 'fail'
            Pony.mail(:to => @report_req["email_id"], :subject => "Web Accessiblity Report: #{report_req["rep_name"]} ", 
            		:body => "The accessiblity report for #{report_req["rep_name"]} has failed. Please rerun or resubmit the report.", :from => 'web_accessiblity@unimelb.edu.au')
         end
		rescue
			puts "Unable to send email for report: #{report_req["submit_id"]}"
            rep = Submit.find(report_req["submit_id"])
			rep.update_attributes(report_run_status: 'mail_fail')
		end
	end

end

