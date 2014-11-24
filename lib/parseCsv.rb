# Public: Class for parsing the contents of a CSV file and returning its contents.
#
# @version: 1.00
# @author: Andrew Normand

require 'csv'
# If using CharlockHolmes Encoding Detector, uncomment this
# require 'charlock_holmes/string'    

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
      @site_addr
      @site_name
      parse_file
   end

   # Private: parses the CSV file and stores the column values in arrays
   def parse_file
      if @csv_source == "siteimprove"
            column_seperator = "\t" 
            # If using CharlockHolmes Encoding Detector, uncomment this
            #detection = CharlockHolmes::EncodingDetector.detect(contents)
            #@csv_encoding = detection[:encoding]
            @csv_encoding = "UTF-16LE"
      elsif @csv_source == "google"         
            column_seperator = ","
            # If using CharlockHolmes Encoding Detector, uncomment this 
            #detection = CharlockHolmes::EncodingDetector.detect(contents)
            #@csv_encoding = detection[:encoding]
            @csv_encoding = "ISO-8859-1"
      end
      contents = File.read(@csv_filename)
      output_encoding = @csv_encoding + ":UTF-8"
      arr_csv_contents = CSV.read(@csv_filename, { :encoding => output_encoding, :headers => true, :col_sep => column_seperator, :skip_blanks => true })
      if @csv_source == "siteimprove"
         @site_name = "Graduate Research"
         @site_addr = "http://gradresearch.unimelb.edu.au"
         arr_csv_contents.each { |row| 
         @arr_of_titles << row[0]
         @arr_of_urls << row[1]
          } 
         # delete the first two rows of the array
         @arr_of_titles = @arr_of_titles.drop(2)
         @arr_of_urls = @arr_of_urls.drop(2) 
      elsif @csv_source == "google" 
         @site_name = "Grainger Museum"
         @site_addr = "http://library.unimelb.edu.au/grainger"
         arr_csv_contents.each { |row| 
         @arr_of_titles << row[0]
         @arr_of_urls << row[1]
          } 
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

      def get_urls(url_count=0)

         if (url_count==0) || (@arr_of_urls.length <= url_count)
            dt = @arr_of_urls
         else
            dt = @arr_of_urls.slice(0,url_count)
         end
         return {"array" => dt, "website" => @site_name, "ip" => @site_addr}
   end

end