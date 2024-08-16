require 'pg'

class DBConnection
  def self.connection
    environment = ENV['RACK_ENV'] || 'development'
    db_name = environment == 'test' ? 'rebase_labs_test' : 'rebase_labs'

    PG.connect(
      host: 'db',
      user: 'postgres',
      password: 'password',
      dbname: db_name
    ).tap do |conn|
      conn.exec("SET client_min_messages TO WARNING;")
    end
  end
end
