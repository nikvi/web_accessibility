#query_wave.rb
require 'parse_csv'
require 'net/http'

class QueryWaveAPI

attr_accessor: url_data
def initialize(file_name,source,report_type=2)
@parser = ParseCSV.new(file_name,source)
@report_type = report_type
end


def get_urls()
  url_data = @parser.get_urls()
  url_data.each { |x| puts x}

end











end