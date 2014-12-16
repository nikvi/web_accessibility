#report_job.rb
require_relative  '../runReports.rb'


require 'sucker_punch'
class ReportJob
   include SuckerPunch::Job

   def perform(report_id)
      ::RunReports.new.run_report_db(report_id)
   end
end