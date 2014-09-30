#databaseAcess.rb

require_relative './models/website.rb'
require './config/environments'
require 'sinatra/activerecord'
require_relative './models/report.rb'
require_relative  './models/page.rb'
require_relative './models/category.rb'
require_relative  './models/description.rb'


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
       @category = @page.categories.create(category_name: x['c_name'],description_name: x['c_desc_name'],description_title: x['c_desc_title'],count: x['c_count'].to_i)
     end
   end
  end


# get list of all websites and their respective report dates

def getAllReports()
    reports = Report.includes(:website).limit(10)
    rep_array = Array.new
    reports.each do |report|
      rep_display = { 
        "web_name"    => report.website.website_name,
        "web_url"     => report.website.website_url,
        "report_date" => report.report_date,
        "report_id"   => report.id
      }
     rep_array << rep_display
    end
    return rep_array
  end


#get the pages for the report_id and all error and alert count associated with the page
  def getReportDetails(report_id)
     pages = Page.where("report_id = ? ",report_id)
     page_array = Array.new
     pages.each do |pg|
       error_count = Category.includes(:page).where(page_id: pg.id, category_name: 'error').count
       alert_count = Category.includes(:page).where(page_id: pg.id, category_name: 'alert').count
       pg_disply ={
          "page_name"   => pg.page_title,
          "page_url"    => pg.page_url,
          "wave_url"    => pg.wave_url,
          "error_count" => error_count,
          "alert_count" => alert_count
       }
       page_array << pg_disply
     end
    return page_array
  end



# def deleteData()
# end
end
