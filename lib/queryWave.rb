 #query_wave.rb
# Public: Class for querying wave API and push results to db
#
# @version: 1.00
# @author: Nikki Vinayan
require_relative './databaseAccess.rb'
require_relative './waveData.rb'
require 'net/http'
require 'json'

class QueryWaveAPI


  def initialize()
  	@db = DBAccess.new()
  end

  #used to query the Wave API andd converst response to ruby object
  def query_wave(url_data)
    response_array = Array.new
    #querying wave
    puts url_data["name"]
  	 url_data["urls"].each do |u|
        resp = Net::HTTP.get_response(URI.parse(u))
        #if resp.is_a?(Net::HTTPSuccess) & resp.body["success"]==true
        case resp
          when Net::HTTPSuccess
            data = JSON.parse(resp.body)
            if(data["status"]["success"])    	    
                page_url   = data["statistics"]["pageurl"]
          		  page_title = data["statistics"]["pagetitle"]
          	 	  wave_url   = data["statistics"]["waveurl"]
                wv_data    = WaveData.new(url_data["submit_id"],page_url,page_title,wave_url)
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
              puts JSON.parse(resp.body)
            end
          else
        		puts "Invalid HTTP response for: "<< u
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

end