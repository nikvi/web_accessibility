#dataBaseAccess_test_harness.rb
require './test_helper.rb'
db_test = DatabaseTest.new
db_test.pushWebsiteToDB("http://gradresearch.unimelb.edu.au","The Melbourne School Of Graduate Research - Home")
db_test.pushReportToDB()
db_test.pushPageToDB()
db_test.pushCategoryToDB()
db_test.pushDescriptionToDB()
