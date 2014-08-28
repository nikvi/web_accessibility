#query_wave_test_harness.rb
require './test_helper.rb'


queryWave = QueryWaveAPI.new("../data_csv/Graduate Research - Page.csv","siteimprove")
queryWave.query_wave(10)