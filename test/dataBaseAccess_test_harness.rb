#dataBaseAccess_test_harness.rb
require './test_helper.rb'
require_relative '../lib/models/website.rb'
require_relative '../lib/models/report.rb'
require_relative '../lib/models/page.rb'
require_relative '../lib/models/category.rb'
require_relative '../lib/models/description.rb'
require 'sinatra/activerecord'
#db_test = DatabaseTest.new
db_test = DBAccess.new
#puts db_test.getAllReports
#puts db_test.getReportDetails('6')
db_test.delete_report('1')
#db_test.pushWebsiteToDB("http://gradresearch.unimelb.edu.au","The Melbourne School Of Graduate Research - Home")
#db_test.pushReportToDB()
#db_test.pushPageToDB()
#db_test.pushCategoryToDB()
#db_test.pushDescriptionToDB()
