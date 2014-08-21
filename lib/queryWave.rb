#query_wave.rb
require_relative './parseCsv.rb'
require 'net/http'
require '../config/waveApiConfig'

class QueryWaveAPI


def initialize(file_name,source,report_type=2)
	@parser      = ParseCSV.new(file_name,source)
	@report_type = report_type

end


def get_urls()
  url_data = @parser.get_urls()
  #url_data.each { |x| puts  WaveConfig::WAVE_API_URL + "key="+WaveConfig::WAVE_API_KEY+ "&url="+ x + "&reporttype="+@report_type }

end











end