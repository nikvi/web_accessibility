# runReports.rb
require './config/waveApiConfig'
require_relative './parseCsv.rb'
require_relative './databaseAccess.rb'
require_relative './queryWave.rb'


class RunReports

def initialize
	@qv = QueryWaveAPI.new
end


# generates the formatted url used to access Wave
def format_url_data(data)
	query_urls = Array.new
	data["array"].each do |x| 
    	str = "#{WaveConfig::WAVE_API_URL}key=#{WaveConfig::WAVE_API_KEY}&url=#{x}&reporttype=#{WaveConfig::REPORT_TYPE}" 
    	query_urls.push str
  	end
	return {"urls" => query_urls, "name" => data["website"], "site" => data["ip"] }
end

def run_reports_csv(file_name,source,url_count=5)
	parser  = ParseCSV.new(file_name,source)
	data    = parser.get_urls(url_count)
    @qv.query_wave(format_url_data(data))
end

def run_reports_web()
	db          = DBAccess.new()
	report_data = db.get_requested_urls()
	report_data.each do |dt|
		@qv.query_wave(format_url_data(dt))
  	end	
end


end

