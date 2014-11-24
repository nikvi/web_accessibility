#dbConfig.rb
Sinatra::Base.configure :development do 
    enable :logging
    #dbconfig = YAML.load(File.read("config/database.yml")).with_indifferent_access
    # running test harness 
    dbconfig = YAML.load(File.read("../config/database.yml")).with_indifferent_access
    set :database, dbconfig[settings.environment]
    ActiveRecord::Base.establish_connection dbconfig[settings.environment]
end