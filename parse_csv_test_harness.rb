# Test Harness for ParseCSV Class
require 'csv'
require 'charlock_holmes/string'   
require './ParseCSV' 

myControlCSV = ParseCSV.new("Graduate Research - Page.csv","siteimprove")
#myControlCSV = ParseCSV.new("Merged Sheet - Sheet1.csv","google")
myControlCSV.get_titles
myControlCSV.get_encoding
