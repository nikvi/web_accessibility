#databaseAcess.rb

require_relative './models/website.rb'
require_relative './models/report.rb'
require_relative './models/page.rb'
require_relative './models/category.rb'
require_relative './models/description.rb'
require '../config/environments'
require 'sinatra/activerecord'


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


# def deleteData()
# end
end
