require_relative '20140508194831_update_search_vector_migration'

class UpdateSearchVectorsToSupportAvailabilities < ActiveRecord::Migration
  def change
    revert UpdateSearchVectorMigration

    reversible do |dir|
      dir.up do
        execute <<-SQL
          DROP TRIGGER locations_search_content_trigger ON locations;
          DROP FUNCTION fill_search_vector_for_location();
        SQL

        execute <<-SQL
          CREATE OR REPLACE FUNCTION fill_search_vector_for_location() RETURNS trigger LANGUAGE plpgsql AS $$
          declare
            location_organization record;
            location_services_keywords record;
            location_services_description record;
            location_services_name record;
            service_categories record;

          begin
            select name into location_organization from organizations where id = new.organization_id;

            select string_agg(keywords, ' ') as keywords into location_services_keywords from services INNER JOIN availabilities ON services.id = availabilities.service_id where availabilities.location_id = new.id;
            select description into location_services_description from services INNER JOIN availabilities ON services.id = availabilities.service_id where availabilities.location_id = new.id;
            select name into location_services_name from services INNER JOIN availabilities ON services.id = availabilities.service_id where availabilities.location_id = new.id;

            select string_agg(categories.name, ' ') as name into service_categories from locations
            JOIN availabilities ON availabilities.location_id = new.id
            JOIN services ON services.id = availabilities.service_id
            JOIN categories_services ON categories_services.service_id = services.id
            JOIN categories ON categories.id = categories_services.category_id;

            new.tsv_body :=
              setweight(to_tsvector('pg_catalog.english', coalesce(new.name, '')), 'B')                  ||
              setweight(to_tsvector('pg_catalog.english', coalesce(new.description, '')), 'A')                ||
              setweight(to_tsvector('pg_catalog.english', coalesce(location_organization.name, '')), 'B')        ||
              setweight(to_tsvector('pg_catalog.english', coalesce(location_services_description.description, '')), 'A')  ||
              setweight(to_tsvector('pg_catalog.english', coalesce(location_services_name.name, '')), 'B')  ||
              setweight(to_tsvector('pg_catalog.english', coalesce(location_services_keywords.keywords, '')), 'B') ||
              setweight(to_tsvector('pg_catalog.english', coalesce(service_categories.name, '')), 'A');

            return new;
          end
          $$;
        SQL

        execute <<-SQL
          CREATE TRIGGER locations_search_content_trigger BEFORE INSERT OR UPDATE
            ON locations FOR EACH ROW EXECUTE PROCEDURE fill_search_vector_for_location();
        SQL

        Location.find_each(&:touch)
      end

      dir.down do
        execute <<-SQL
          DROP TRIGGER locations_search_content_trigger ON locations;
          DROP FUNCTION fill_search_vector_for_location();
        SQL
      end

    end
  end
end
