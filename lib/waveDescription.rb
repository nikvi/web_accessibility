#WaveDescription.rb
# Public: Class for loading WAVE API descriptions and pushing them to db
#
# @version: 1.00
# @author: Andrew Normand
require_relative './databaseAccess.rb'
require_relative '../lib/models/description.rb'
require 'json'
require 'open-uri'

class WaveDescription

  def initialize()
    source = "http://wave.webaim.org/api/docs.php"
    @data = JSON.load(open(source))
  end

  def push_descriptions_to_db()
    @data.each do |d|
      name = d["name"]
      title = d["title"]
      type = d["type"]
      summary = d["summary"]
      insert_description(name, title, type, summary)
    end
  end

  def insert_description(name, title, type, summary)
    @description = Description.new(name: name, title: title, type: type, summary: summary)
    if  @description.save
      puts("saved")
    else
      puts ("error")
    end
  end

end
