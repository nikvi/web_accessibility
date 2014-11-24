# Test Harness for ParseCSV Class
require './test_helper.rb'

#myControlCSV = ParseCSV.new("../data_csv/Graduate Research - Page.csv","siteimprove")
myControlCSV = ParseCSV.new("../data/Merged Sheet - Sheet1.csv","google")
myControlCSV.get_titles
myControlCSV.get_urls
myControlCSV.get_encoding
