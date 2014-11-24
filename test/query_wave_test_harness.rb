#query_wave_test_harness.rb
require './test_helper.rb'


#queryWave = QueryWaveAPI.new("../data_csv/Graduate Research - Page.csv","siteimprove",10)
#queryWave = QueryWaveAPI.new("../data_csv/Merged Sheet - Sheet1.csv","google",8)
queryWave = QueryWaveAPI.new("../data_csv/Grainger_Museum.csv","google",6)
queryWave.query_wave()


