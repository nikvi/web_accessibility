  #query_wave.rb
 # Public: Class for querying wave API and push results to db
#
# @version: 1.00
# @author: Nikki Vinayan
require_relative './parseCsv.rb'
require_relative './databaseAcess.rb'
require 'net/http'
require '../config/waveApiConfig'
require 'json'

class QueryWaveAPI


def initialize(file_name,source,report_type=2)
	@parser      = ParseCSV.new(file_name,source)
	@db          = DBAccess.new()
	@report_type = report_type

end

# generates the formatted url used to access Wave
def get_urls(count)
	url_data = @parser.get_urls
	query_urls = Array.new
	url_data[0..(count-1)].each do |x| 
  		str = "#{WaveConfig::WAVE_API_URL}key=#{WaveConfig::WAVE_API_KEY}&url=#{x}&reporttype=#{@report_type}" 
    	query_urls.push str
  	end
	return query_urls
end


#used to query the Wave API and then pass on data to dataBase layer
def query_wave(count)

	urls = get_urls(count)
	resp_array = Array.new
	urls[0..0].each do |u|
    	resp = Net::HTTP.get_response(URI.parse(u))
    	#data is added only is the request is successful
    	data = resp.body if resp.is_a?(Net::HTTPSuccess)
    	dt = JSON.parse(data)
    	if dt["status"]["success"]    	    
    	  	page_url = data["statistics"]["pageurl"]
    		page_title = data["statistics"]["pagetitle"]
    		wave_url = data["statistics"]["waveurl"]
    		#create an array for errors
    		# error_count = data["categories"]["error"]["items"]
    		# alert_count = data["categories"]["alert"] ["items"].length
    		puts page_url + " " + page_title +" " + wave_url 
    	 else
    		puts "error"
    	 end

    	#resp_array.push JSON.parse(resp.body) if resp.is_a?(Net::HTTPSuccess)
	end
	#@db.pushToDB(resp_array)
end








end