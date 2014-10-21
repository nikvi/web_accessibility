#database_cleaner_spec.rb

require_relative 'spec_helper.rb'
require 'yaml'
require 'database_cleaner'



DatabaseCleaner[:active_record, :connection => :test].clean_with :truncation

DatabaseCleaner[:active_record, :connection => :test].strategy = :transaction

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

end