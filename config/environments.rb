#dbConfig.rb
Sinatra::Base.configure :development, :production do 
    enable :logging
    db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
 
	ActiveRecord::Base.establish_connection(
			:adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
			:host     => db.host,
			:username => db.user,
			:password => db.password,
			:database => db.path[1..-1],
			:encoding => 'utf8'
	)
	# running test harness 
    #dbconfig = YAML.load(File.read("../config/database.yml")).with_indifferent_access
    #set :database, dbconfig[settings.environment]
    #ActiveRecord::Base.establish_connection dbconfig[settings.environment]
end