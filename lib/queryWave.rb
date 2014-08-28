#query_wave.rb
require_relative './parseCsv.rb'
require 'net/http'
require '../config/waveApiConfig'

class QueryWaveAPI


def initialize(file_name,source,report_type=2)
	@parser      = ParseCSV.new(file_name,source)
	@report_type = report_type

end


def get_urls(count)
	url_data = @parser.get_urls
	query_urls = Array.new
	url_data[0..(count-1)].each do |x| 
  		str = "#{WaveConfig::WAVE_API_URL}key=#{WaveConfig::WAVE_API_KEY}&url=#{x}&reporttype=#{@report_type}" 
    	query_urls.push str
  	end
	return query_urls
end


def query_wave(count)

	url = get_urls(count)
	url.each do |u|
    	resp = Net::HTTP.get_response(URI.parse(u))
    	puts resp.body
	end
end








end