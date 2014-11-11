 #query_wave.rb
# Public: Class for querying wave API and push results to db
#
# @version: 1.00
# @author: Nikki Vinayan
require_relative './parseCsv.rb'
require_relative './databaseAccess.rb'
require_relative './waveData.rb'
require 'net/http'
require '../config/waveApiConfig'
require 'json'

class QueryWaveAPI


def initialize(file_name,source,url_count=0,report_type=2)
	@parser      = ParseCSV.new(file_name,source)
	@db          = DBAccess.new()
	@report_type = report_type
  @url_count   = url_count

end

# generates the formatted url used to access Wave
def get_urls()
	data = @parser.get_urls(@url_count)
	query_urls = Array.new
	data["array"].each do |x| 
  		str = "#{WaveConfig::WAVE_API_URL}key=#{WaveConfig::WAVE_API_KEY}&url=#{x}&reporttype=#{@report_type}" 
    	query_urls.push str
  	end
	return {"urls" => query_urls, "name" => data["website"], "site" => data["ip"] }
end


#used to query the Wave API andd converst response to ruby object
def query_wave()

	url_data = get_urls()
	response_array = Array.new
  #querying wave
  puts url_data["name"]
	url_data["urls"].each do |u|
    	resp = Net::HTTP.get_response(URI.parse(u))
        if resp.is_a?(Net::HTTPSuccess) & resp.body["success"]==true
    	   data = JSON.parse(resp.body)
        	if (data["status"]["success"])    	    
        	  	page_url = data["statistics"]["pageurl"]
        		  page_title = data["statistics"]["pagetitle"]
        	 	  wave_url = data["statistics"]["waveurl"]
              wv_data = WaveData.new(url_data["site"],url_data["name"],page_url,page_title,wave_url)
              error_data = data["categories"]["error"]["items"]
              if (WaveConfig::ERROR_FLG and !error_data.empty?)
                wv_data.createCategories(error_data,"error") 
              end
              if WaveConfig::ALERT_FLG
                alert_data = data["categories"]["alert"]["items"]
                wv_data.createCategories(alert_data,"alert") if !alert_data.empty?
              end
              if WaveConfig::STRUCTURE_FLG
                struct_data = data["categories"]["structure"]["items"]
                wv_data.createCategories(struct_data,"structure") if !struct_data.empty?
             end
              response_array <<wv_data
            else
               puts "Error in Wave Response" 
            end
        else
    		puts "Invalid HTTP response"
    	end
    end


    #persisting to database
     if !response_array.empty?
        pushResponse(response_array)
      end
end

#Method used to push the waveData objects to database
def pushResponse(responses)
     responses.each do |x|
        @db.persistWaveData(x)
     end
end

# test code
def parse_data()
js = 
'{"status":{"success":true},"statistics":{"pagetitle":"The Melbourne School Of Graduate Research - Home","pageurl":"http:\/\/gradresearch.unimelb.edu.au","time":"2.78","allitemcount":78,"totalelements":236,"creditsremaining":"2451","waveurl":"http:\/\/wave.webaim.org\/report?url=http:\/\/gradresearch.unimelb.edu.au"},"categories":{"error":{"description":"Errors","count":1,"items":{"label_missing":{"id":"label_missing","description":"Missing form label","count":1}}},"alert":{"description":"Alerts","count":31,"items":{"alt_duplicate":{"id":"alt_duplicate","description":"A nearby image has the same alternative text","count":2},"heading_skipped":{"id":"heading_skipped","description":"Skipped heading level","count":1},"heading_possible":{"id":"heading_possible","description":"Possible heading","count":1},"link_suspicious":{"id":"link_suspicious","description":"Suspicious link text","count":8},"link_redundant":{"id":"link_redundant","description":"Redundant link","count":17},"title_redundant":{"id":"title_redundant","description":"Redundant title text","count":2}}},"feature":{"description":"Features","count":15,"items":{"alt_null":{"id":"alt_null","description":"Null or empty alternative text","count":8},"alt_link":{"id":"alt_link","description":"Linked image with alternative text","count":7}}},"structure":{"description":"Structural Elements","count":29,"items":{"h1":{"id":"h1","description":"Heading level 1","count":1},"h2":{"id":"h2","description":"Heading level 2","count":13},"h3":{"id":"h3","description":"Heading level 3","count":10},"h5":{"id":"h5","description":"Heading level 5","count":1},"ul":{"id":"ul","description":"Unordered list","count":4}}},"html5":{"description":"HTML5 and ARIA","count":1,"items":{"aria_landmark":{"id":"aria_landmark","description":"ARIA landmark","count":1}}},"contrast":{"description":"Contrast Errors","count":1,"items":{"contrast":{"id":"contrast","description":"Very Low Contrast","count":1}}}}}'
data = JSON.parse(js)
if (data["status"]["success"])
        page_url = data["statistics"]["pageurl"]
        page_title = data["statistics"]["pagetitle"]
        wave_url = data["statistics"]["waveurl"]
        #need to access the  webpage and weburl
        wv_data = WaveData.new("http://gradresearch.unimelb.edu.au","Graduate Research",page_url,page_title,wave_url)
        #wv_data.createCategories(data["categories"]["alert"] ["items"],"alert")
        wv_data.createCategories(data["categories"]["error"]["items"],"error")
        @db.pushWaveData(wv_data)
else
    puts "error"
end
end

end