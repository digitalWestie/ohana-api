class AddSearchVectorToServices < ActiveRecord::Migration
  def up
    # 1. Create the search vector column
    add_column :services, :search_vector, 'tsvector'

    # 2. Create the gin index on the search vector
    execute <<-SQL
      CREATE INDEX services_search_idx
      ON services
      USING gin(search_vector);
    SQL

    # 4 (optional). Trigger to update the vector column
    # when the services table is updated
    execute <<-SQL
      DROP TRIGGER IF EXISTS services_search_vector_update
      ON services;
      CREATE TRIGGER services_search_vector_update
      BEFORE INSERT OR UPDATE
      ON services
      FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger (search_vector, 'pg_catalog.english', name, description, keywords );
    SQL

    Service.find_each { |p| p.touch }
  end

  def down
    remove_column :services, :search_vector
    execute <<-SQL
      DROP TRIGGER IF EXISTS services_search_vector_update on services;
    SQL
  end
end
