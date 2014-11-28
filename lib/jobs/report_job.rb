#report_job.rb

require 'sucker_punch'
class ReportJob
   include SuckerPunch::Job
   workers 3

   def perform(report_id)
      ::RunReports.run_report_db(report_id)
   end
end