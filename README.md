## Container locations
- `/var/lib/postgresql/gisdata/`: temp folder and staging for this container

## Post container creation set-up
run `post-install` script. It installs DC data only.

- windows: `cmd /c post-intall.bat`
- linux: `./post-intall.sh`

## Test use-cases
- template
  ```
  docker exec some-postgis-geocoder psql -U postgres -d geocoder -c "<YOUR SQL GOES HERE (paste it in 1 line)>"
  ```
- query #1 geocoder usage
  ```
  SELECT g.rating, ST_X(g.geomout) As lon, ST_Y(g.geomout) As lat, (addy).address As stno, (addy).streetname As street, (addy).streettypeabbrev As styp, (addy).location As city, (addy).stateabbrev As st,(addy).zip FROM geocode('1600 Pennsylvania Ave NW, Washington, DC 20500') As g;
  ```
  pprinted
  ```
    SELECT 
        g.rating, 
        ST_X(g.geomout) As lon, 
        ST_Y(g.geomout) As lat, 
        (addy).address As stno, 
        (addy).streetname As street, 
        (addy).streettypeabbrev As styp, 
        (addy).location As city, 
        (addy).stateabbrev As st,
        (addy).zip 
    FROM geocode('1600 Pennsylvania Ave NW, Washington, DC 20500') As g;
  ```
- query #2 reverse geocoder usage
  ```
  SELECT pprint_addy(r.addy[1]) As st1, pprint_addy(r.addy[2]) As st2, pprint_addy(r.addy[3]) As st3, array_to_string(r.street, ',') As cross_streets  FROM reverse_geocode(ST_GeomFromText('POINT(-77.00046877117504 38.8875068167358)',4269),true) As r;
  ```
  pprinted
  ```
    SELECT 
        pprint_addy(r.addy[1]) As st1, 
        pprint_addy(r.addy[2]) As st2, 
        pprint_addy(r.addy[3]) As st3, 
        array_to_string(r.street, ',') As cross_streets 
    FROM reverse_geocode(ST_GeomFromText('POINT(-77.00046877117504 38.8875068167358)',4269),true) As r;
  ```