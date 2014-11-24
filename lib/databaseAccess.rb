#databaseAcess.rb

require_relative './models/website.rb'
# when running test Harness , commnet out--
#require './config/environments'
require 'sinatra/activerecord'
require_relative './models/report.rb'
require_relative  './models/page.rb'
require_relative './models/category.rb'
require_relative  './models/description.rb'
require_relative  './models/submit.rb'


class DBAccess

	def initialize()
   
	end
   
   
# the incoming json data is stored in DB
  def persistWaveData(wave_data)
     time = Time.now
     @website = Website.find_or_create_by(website_url: wave_data.website_url, website_name: wave_data.website_name)
     #currently only storing data as multiple vlaues getting created
     @report = @website.reports.find_or_create_by(report_date: time.strftime("%Y-%m-%d") )
     @page = @report.pages.find_or_create_by(page_url: wave_data.page_url, page_title: wave_data.page_title, wave_url: wave_data.wave_url)
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
       @report.save
    end
  end

# populate the report table with pages and total error count data:

def generateSummary(id)
     summary = {
     "pg_count" =>  Page.where(report_id: id).count,
     "pg_error" =>  Page.includes("categories").where(report_id: id, categories:{ category_name: 'error'}).count,
     "totl_err" =>  Category.joins(:page).where(category_name: 'error',pages: { report_id: id}).sum('count'),
     "totl_alrt" => Category.joins(:page).where(category_name: 'alert',pages: { report_id: id}).sum('count')
    }
  end

#add the web_urls for which reports need to to be generated
 def persistURLS(url,rName)
    time = Time.now
    submit = Submit.create(web_url: url,report_name: rName, submit_date: time.strftime("%Y-%m-%d"))
 end 

# get list of all websites and their respective report dates

def getAllReports()
    reports = Report.includes(:website).limit(10)
    report_error = Category.select("description_name as error_name, sum(count) as total_errors").where(category_name: 'error').group("description_name");
    error_sum = Hash.new
    report_error.each do |ech_err|
      error_sum[ech_err.error_name] = ech_err.total_errors
    end
    rep_array = Array.new
    reports.each do |report|
      totl_error = report.total_errors
      if totl_error.nil?
        error_avg = 0
      elsif !(report.pages_total.nil?)
        error_avg = totl_error.to_f / report.pages_total
      end
      rep_display = { 
        "web_name"    => report.website.website_name,
        "web_url"     => report.website.website_url,
        "report_date" => report.report_date.strftime("%d %B, %Y"),
        "report_id"   => report.id,
        "pg_totl"     => report.pages_total.nil? ? 0 : report.pages_total,
        "error_free"  => (report.pages_total).to_i - (report.pages_error).to_i,
        "error_aver"  => error_avg
      }
      rep_array << rep_display
    end
    puts error_sum
    return  {"rep_data" => rep_array,"rep_errors" => error_sum}
  end


#get the pages for the report_id and all error and alert count associated with the page
#
  def getReportDetails(report_id)
     report_data            = Hash.new
     summary                = getReportSummary(report_id)
     report_data["errors"]  = getErrorDetails(report_id)
     report_data["summary"] = summary
     pages                  = Page.where("report_id = ? ",report_id)
     page_array             = Array.new
     pages.each do |pg|
       error_count = Category.includes(:page).where(page_id: pg.id, category_name: 'error').sum('count')
       errors    = Category.select(:description_name).where(page_id: pg.id, category_name: 'error')
       error_arr = Set.new
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

#returns the data required for the summary of the report
def getReportSummary(id)
  data                  = Hash.new
  report                = Report.find(id)
  data["pg_totl"]       = report.pages_total
  tot_err               = report.total_errors
  tot_alrt              = report.total_alerts
  if tot_err.nil?
    data["error_totl"]    = 0
    data["error_average"] = 0
  else
      data["error_totl"]  = tot_err
      data["error_average"] = tot_err.to_f / report.pages_total
  end
  data["error_free"]    = (report.pages_total).to_i - (report.pages_error).to_i
  if tot_alrt.nil?
    data["alert_average"] = 0
  else
    data["alert_average"] = tot_alrt.to_f/report.pages_total
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





 def delete_report(id)
   report = Report.find(id)
   report.destroy
end




end
