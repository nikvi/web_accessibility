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
     wave_data.categories.each do |x|
       @category = @page.categories.create(category_name: x['c_name'],description_name: x['c_desc_name'],description_title: x['c_desc_title'],count: x['c_count'].to_i)
     end
  end


# def deleteData()
# end





   def pushWebsiteToDB(web_url,web_name)

   	@website = Website.new(website_url: "http://gradresearch.unimelb.edu.au", website_name: "The Melbourne School Of Graduate Research - Home")
   	if  @website.save
   		 puts("saved")

   	else
   		puts ("error")
   	end
    end 
    
    def pushReportToDB()

      @@time1 = Time.now.to_s(:db)
      @report = Report.new(website_id: "1", report_date: @@time1)
      if  @report.save
          puts("saved")

      else
         puts ("error")
      end
   end

   def pushPageToDB()

      @page = Page.new(report_id: "1", page_url: "http://library.unimelb.edu.au", page_title: "Library Home Page", wave_url: "http://wave.webaim.org/report#/library.unimelb.edu.au")
      if  @page.save
          puts("saved")

      else
         puts ("error")
      end
   end  

   def pushCategoryToDB()

      @category = Category.new(page_id: "1", category_name: "Errors", description_name: "Missing alt text", description_title: "Alt attribute missing", count: "21")
      if  @category.save
          puts("saved")

      else
         puts ("error")
      end
   end

   def pushDescriptionToDB()

      @description = Description.new(name: "Headings", title: "Heading 3", type: "Incorrect heading", summary: "The headings are not validly nested")
      if  @description.save
          puts("saved")

      else
         puts ("error")
      end
   end


end
