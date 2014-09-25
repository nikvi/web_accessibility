#dataBase_test.rb
require './test_helper.rb'
require_relative '../lib/models/website.rb'
require_relative '../lib/models/report.rb'
require_relative '../lib/models/page.rb'
require_relative '../lib/models/category.rb'
require_relative '../lib/models/description.rb'
require '../config/environments'
require 'sinatra/activerecord'


class DatabaseTest

def	initialize()
end


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