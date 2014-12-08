#config.ru

require "rubygems"



require "bundler/setup"

require "sinatra"

require "seed_dump"

require "haml"

require "./app"

set :run, false

set :raise_errors, true

haml_template = File.read(File.join('views','test.haml'))
configure :production do
  Pony.options = {
      :via => :smtp,
      :via_options => {
        :address => 'smtp.sendgrid.net',
        :port => '587',
        :domain => 'heroku.com',
        :user_name => ENV['SENDGRID_USERNAME'],
        :password => ENV['SENDGRID_PASSWORD'],
        :authentication => :plain,
        :enable_starttls_auto => true
      }
    }
end

run Sinatra::Application