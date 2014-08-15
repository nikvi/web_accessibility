# parse_csv.rb
# this file parses CSV files generated from SiteImprove
require 'csv'
require 'charlock_holmes/string'    

# specify the filename of the CSV file
file="Graduate Research - Page.csv"

# use CharlockHolmes to determine the encoding of the csv file
contents = File.read(file)
detection = CharlockHolmes::EncodingDetector.detect(contents)
# puts detection

# parse the CSV file into an array of arrays
arr_csv_contents = CSV.read(file, { :encoding => "UTF-16LE:UTF-8", :headers => true, :col_sep => "\t", :skip_blanks => true })

# get the total number of array items
# puts arr_csv_contents.length

# declare the names of the column arrays
arr_of_titles = []
arr_of_urls = []

# loop through the CSV and store the contents as column arrays
arr_csv_contents.each { |row| 
	arr_of_titles << row[0]
	arr_of_urls << row[1]
}

# get the title of the CSV
site_name = arr_of_titles[0]

# delete the first two rows of the array
arr_of_titles = arr_of_titles.drop(2)
arr_of_urls = arr_of_urls.drop(2)

# display the site name and titles
puts site_name
puts arr_of_titles
