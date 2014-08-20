# Public: Class for parsing the contents of a CSV file and returning its contents.
#
# @version: 1.00
# @author: Andrew Normand

require 'csv'
require 'charlock_holmes/string'    

class ParseCSV
   # Public: ParseCSV constructor
   #
   # filename - A String containing the path to the CSV file to be parsed.
   # source - A String describing where the CSV came from (examples: "siteimprove", "google")
   def initialize(filename,source)
      @csv_filename=filename
      @csv_source=source
      @str_encoding
      # declare the names of the column arrays
      @arr_of_titles = []
      @arr_of_urls = []
      parse_file
   end

   # Private: parses the CSV file and stores the column values in arrays
   def parse_file
      if @csv_source == "siteimprove"
            column_seperator = "\t" 
      elsif @csv_source == "google"         
            column_seperator = ","
      end
      contents = File.read(@csv_filename)
      detection = CharlockHolmes::EncodingDetector.detect(contents)
      @csv_encoding = detection[:encoding]
      output_encoding = @csv_encoding + ":UTF-8"
      arr_csv_contents = CSV.read(@csv_filename, { :encoding => output_encoding, :headers => true, :col_sep => column_seperator, :skip_blanks => true })

      arr_csv_contents.each { |row| 
         @arr_of_titles << row[0]
         @arr_of_urls << row[1]
      } 

      if @csv_source == "siteimprove"
         # delete the first two rows of the array
         @arr_of_titles = @arr_of_titles.drop(2)
         @arr_of_urls = @arr_of_urls.drop(2) 
      end
   end

   # Public: returns the encoding of CSV file
   def get_encoding()
      puts @csv_encoding
   end

   # Public: returns the first column of the CSV file as an array
   def get_titles()
      puts @arr_of_titles
   end

end