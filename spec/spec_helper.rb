require 'rack/test'
require 'rspec'
require 'pg'
require_relative '../app/main'
require_relative '../lib/import_from_csv'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  config.before(:suite) do
    connection = PG.connect(
      host: 'db',
      user: 'postgres',
      password: 'password',
      dbname: 'postgres'
    )

    connection.exec("CREATE DATABASE rebase_labs_test;") rescue PG::DuplicateDatabase

    connection.close

    db_connection = PG.connect(
      host: 'db',
      user: 'postgres',
      password: 'password',
      dbname: 'rebase_labs_test'
    )

    load File.expand_path('../../lib/import_from_csv.rb', __FILE__)

    db_connection.exec("TRUNCATE TABLE exams, tests, doctors, patients RESTART IDENTITY CASCADE;")
    db_connection.close
  end

  config.around(:each) do |example|
    db_connection = PG.connect(
      host: 'db',
      user: 'postgres',
      password: 'password',
      dbname: 'rebase_labs_test'
    )

    db_connection.exec("BEGIN;")
    example.run
    db_connection.exec("ROLLBACK;")

    db_connection.close
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random
  Kernel.srand config.seed
end
