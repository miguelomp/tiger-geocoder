#!/bin/sh

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

# Create the 'template_postgis' template db
psql <<EOSQL
  CREATE DATABASE template_postgis IS_TEMPLATE true;
EOSQL

# Load PostGIS into both template_database and $POSTGRES_DB
for DB in template_postgis "$POSTGRES_DB"; do
  echo "Loading PostGIS extensions into $DB"
    psql --dbname="$DB" <<EOSQL
      CREATE EXTENSION IF NOT EXISTS postgis;
      CREATE EXTENSION IF NOT EXISTS postgis_topology;
      CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
      CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;

      INSERT INTO tiger.loader_platform(os, declare_sect, pgbin, wget, unzip_command, psql, path_sep, loader, environ_set_command, county_process_command)
      SELECT 'geocoder', 
             'TMPDIR="/var/lib/postgresql/gisdata/temp/"
UNZIPTOOL="/usr/bin/unzip"
WGETTOOL="/usr/bin/wget"
export PGBIN=/usr/lib/postgresql/${PG_MAJOR}/bin
export PGPORT=5432
export PGHOST=localhost
export PGUSER=postgres
export PGPASSWORD=postgres
export PGDATABASE=geocoder
PSQL=psql
SHP2PGSQL=/usr/bin/shp2pgsql
cd /var/lib/postgresql/gisdata', 
             pgbin, 
             'wget --no-check-certificate', 
             unzip_command, 
             psql, 
             path_sep, 
             loader, 
             environ_set_command, 
             county_process_command
      FROM tiger.loader_platform WHERE os = 'sh';

      UPDATE tiger.loader_variables
      SET staging_fold='/var/lib/postgresql/gisdata'
      WHERE staging_fold='/gisdata';
EOSQL
done

mkdir -p /var/lib/postgresql/gisdata/temp
chmod 777 /var/lib/postgresql/gisdata

psql -d $POSTGRES_DB -o /var/lib/postgresql/gisdata/nation.sh -A -t -c "SELECT loader_generate_nation_script('geocoder');"
chmod +x /var/lib/postgresql/gisdata/nation.sh
