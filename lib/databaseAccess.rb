  #databaseAcess.rb
  # when running test Harness , commnet out--
  #require './config/environments'
  require 'sinatra/activerecord'
  require_relative './models/report.rb'
  require_relative  './models/page.rb'
  require_relative './models/category.rb'
  require_relative  './models/description.rb'
  require_relative  './models/submit.rb'

class DBAccess

  # the incoming json data is stored in DB
    def persistWaveData(wave_data)
       time     = Time.now
       @submit =  Submit.find(wave_data.submit_id)
       #currently only storing data as multiple vlaues getting created
       @report  = @submit.reports.find_or_create_by(report_date: time.strftime("%Y-%m-%d"))
       @page    = @report.pages.find_or_create_by(page_url: wave_data.page_url, page_title: wave_data.page_title, wave_url: wave_data.wave_url)

      if !wave_data.categories.empty?
        wave_data.categories.each do |x|
          @category = @page.categories.find_or_create_by(category_name: x['c_name'],description_name: x['c_desc_name'],description_title: x['c_desc_title'],count: x['c_count'].to_i)
        end
     end 
      report_sum = generateSummary(@report.id)
      Report.transaction do
         @report.pages_total  = report_sum["pg_count"]
         @report.pages_error  = report_sum["pg_error"]
         @report.total_errors = report_sum["totl_err"]
         @report.total_alerts = report_sum["totl_alrt"]
         @report.error_avg    = report_sum["error_avg"]
         @report.save
      end
      cleanupOldData(@report.id,@submit.id)
    end

  #delete the pages and categories data for earlier reports:
  def cleanupOldData(report_id,submit_id)
     report_ids = Report.where(submit_id:submit_id).where.not(id: report_id).select("id")
    unless report_ids.nil? || report_ids.length==0
      Page.destroy_all(["report_id in (?)", report_ids])
    end
  end

  #populate the report table with pages and total error count data:
    def generateSummary(id)
        totl_error  = Category.joins(:page).where(category_name: 'error',pages: { report_id: id}).sum('count')
        pages_total = Page.where(report_id: id).count
        pg_error    = Page.includes("categories").where(report_id: id, categories:{ category_name: 'error'}).count
        totl_alrt   = Category.joins(:page).where(category_name: 'alert',pages: { report_id: id}).sum('count')
        if totl_error.nil?
          error_avg = 0
        elsif !(pages_total.nil?)
          error_avg = (totl_error.to_f / pages_total).round(2)
        end
       summary = {
       "pg_count"  =>  pages_total,
       "pg_error"  =>  pg_error,
       "totl_err"  =>  totl_error,
       "totl_alrt" => totl_alrt,
       "error_avg" => error_avg
        }
      return summary
    end

  #add the web_urls for which reports need to to be generated
   def persistURLS(url,rName,pg_urls,rEmail)
      page_value = pg_urls.gsub(/[\r\t\n]+/,",")
      time       = Time.now
      submit     = Submit.create(website_url: url,report_name: rName,pg_urls: page_value,submit_date: time.strftime("%Y-%m-%d"),email_id: rEmail,report_run_status: 'submit')
   end 

  # get list of all websites and their respective report dates
    def getAllReports()
      #reports      = Report.includes(:submit).order('error_avg ASC','pages_error ASC','total_errors ASC','total_alerts ASC', 'report_date DESC')
      reports        = Report.find_by_sql("select u.* from  
                         (select submit_id, 
                          max(report_date) as MaxCreated from 
                          reports group by submit_id
                          ) mu inner join reports u on mu.submit_id = u.submit_id and mu.MaxCreated = u.report_date 
                          order by u.error_avg, u.pages_error, u.total_errors, u.total_alerts, u.report_date DESC")
      rep_array    = Array.new
      reports.each_with_index do |report,index|
        rep_display = { 
          "rep_name"    => report.submit.report_name,
          "web_url"     => report.submit.website_url,
          "report_date" => report.report_date.strftime("%d %b, %Y"),
          "report_id"   => report.id,
          "pg_totl"     => report.pages_total.nil? ? 0 : report.pages_total,
          "error_free"  => (report.pages_total).to_i - (report.pages_error).to_i,
          "error_aver"  => report.error_avg.round(2),
          "rank"        => index+1
        }
        rep_array << rep_display
      end
      error_sum = getAllErrors()
      return  {"rep_data" => rep_array,"rep_errors" => error_sum}
    end

    def getAllErrors()
      report_error = Category.select("description_name as error_name, sum(count) as total_errors").where(category_name: 'error').group("description_name");
      error_sum    = Hash.new
      report_error.each do |ech_err|
        error_sum[ech_err.error_name] = ech_err.total_errors
      end
      return error_sum 
    end 


  #get the pages for the report_id and all error and alert count associated with the page
    def getReportDetails(report_id)
      report_data                = Hash.new
      @report                    = Report.find(report_id)
      report_data["errors"]      = getErrorDetails(report_id)
      report_data["summary"]     = getReportSummary(@report)
      report_data["old_reports"] = getOldReports(@report.id,@report.submit_id)
      page_array                 = Array.new
      pages                      = Page.where("report_id = ? ",report_id)
      pages.each do |pg|
        error_count = Category.includes(:page).where(page_id: pg.id, category_name: 'error').sum('count')
        errors      = Category.select(:description_name).where(page_id: pg.id, category_name: 'error')
        error_arr   = Set.new
        errors.each do |er|
          error_arr.add(er.description_name)
        end
        alert_count = Category.includes(:page).where(page_id: pg.id, category_name: 'alert').sum('count')
        pg_disply   = {
          "page_name"   => pg.page_title,
          "page_url"    => pg.page_url,
          "wave_url"    => pg.wave_url,
          "errors"      => error_arr,
          "error_count" => error_count,
          "alert_count" => alert_count
         }
        page_array << pg_disply
      end
      report_data["pg_data"] = page_array

      return report_data
    end

  #get the data on earlier reports
   def getOldReports(report_id,submit_id)
       earlier_reports = Report.where(submit_id: submit_id)
       old_rep_summary = Array.new
       unless earlier_reports.nil? || earlier_reports.empty?
        earlier_reports.each do |rep|
          rep_summary  = {
          "report_date" => rep.report_date,
          "error_aver"  => rep.error_avg.round(2)
         }
         old_rep_summary << rep_summary
        end
      end
      return old_rep_summary
   end



  #returns the data required for the summary of the report
    def getReportSummary(report)
      data                  = Hash.new
      data["pg_totl"]       = report.pages_total
      data["error_totl"]    = report.total_errors
      data["error_free"]    = (report.pages_total).to_i - (report.pages_error).to_i
      data["error_average"] = report.error_avg.round(2)
      tot_alrt              = report.total_alerts
      if tot_alrt.nil?
        data["alert_average"] = 0
      else
        data["alert_average"] = (tot_alrt.to_f/report.pages_total).round(2)
      end
      return data
    end

  #returns the data to display the error breakdown piechart
    def getErrorDetails(id)
        error_det = Hash.new
        errors    = Category.joins("JOIN pages ON categories.page_id = pages.id")
                               .select("description_name as error_name, sum(count) as total_errors").where(category_name: 'error','pages.report_id' => id).group("description_name");
        errors.each do |err|
          error_det[err.error_name]  = err.total_errors
        end
        return error_det
    end
  
  #get all requested reports
    def getReportRequests()
      rep_req = Submit.where(report_run_status: ['submit','running','rerun'])
      request = Array.new
      rep_req.each do |req|
        rep_req = {
          "id"          => req.id,
          "report_name" => req.report_name,
          "url"         => req.website_url,
          "status"      => req.report_run_status,
          "submit_date" => req.submit_date.strftime("%d %B, %Y")
        }
      request << rep_req  
      end
     return request
    end

  #delete the report 
    def delete_report(id)
     report = Report.find(id)
     submit = Submit.find(report.submit_id)
     destroy submit
    end

  #update requested report status to running:
    def updateReqReportStatus(id)
      report_request = Submit.find(id)
      report_request.update(report_run_status: 'running')
    end

    def rerunReport(rep_id)
        sub_id = Submit.joins(:reports).where(reports: {id: rep_id}).select("id")
        report_req= Submit.find(sub_id)
        report_req.update(report_run_status: 'rerun', submit_date: Time.now.strftime("%Y-%m-%d"))
    end

end
