#sucker_punch.rb
  SuckerPunch.config do
  queue name: :report_queue, worker: ReportJob, workers: 5
  end