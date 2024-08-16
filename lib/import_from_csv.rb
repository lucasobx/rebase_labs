require_relative 'db_connection'
require_relative 'schema_setup'
require_relative 'importer'

SchemaSetup.create_tables

csv_file_path = File.expand_path('../data/data.csv', __dir__)
importer = Importer.new(csv_file_path)
importer.import_data
