#dataBaseAccess_test_harness.rb
require './test_helper.rb'
dbAccess = DBAccess.new
dbAccess.pushWebsiteToDB()
dbAccess.pushReportToDB()
dbAccess.pushPageToDB()
dbAccess.pushCategoryToDB()
dbAccess.pushDescriptionToDB()
