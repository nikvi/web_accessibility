#dbConfig.rb
Sinatra::Base.configure :development do 
	#'postgres://user:pass@localhost/dbname'
    enable :logging
    db = URI.parse(ENV['DATABASE_URL'] || 'postgres://postgres:tiger@localhost/accessibility-reports')

    ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database   => db.path[1..-1],
    :encoding   => 'utf8'
    )
end