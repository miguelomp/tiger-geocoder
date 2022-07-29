docker exec some-postgis-geocoder bash /var/lib/postgresql/gisdata/nation.sh
docker exec some-postgis-geocoder psql -U postgres -d geocoder -o /var/lib/postgresql/gisdata/DC.sh -A -t -c "SELECT loader_generate_script(ARRAY['DC'], 'geocoder') AS result;"
docker exec some-postgis-geocoder chmod +x /var/lib/postgresql/gisdata/DC.sh
docker exec some-postgis-geocoder bash /var/lib/postgresql/gisdata/DC.sh
docker exec some-postgis-geocoder psql -U postgres -d geocoder -c "SELECT install_missing_indexes();"
docker exec some-postgis-geocoder psql -U postgres -d geocoder -c "SELECT g.rating, ST_X(g.geomout) As lon, ST_Y(g.geomout) As lat, (addy).address As stno, (addy).streetname As street, (addy).streettypeabbrev As styp, (addy).location As city, (addy).stateabbrev As st,(addy).zip FROM geocode('1600 Pennsylvania Ave NW, Washington, DC 20500') As g;"