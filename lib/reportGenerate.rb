#reportGenerate.rb
require 'thinreports'
require './views/reports/accessiblity_rpeort.tlf'

report = ThinReports::Report.create do |r|
 r.use_layout 'accessiblity_rpeort.tlf' do |config|
 	
end