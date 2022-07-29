FROM  postgis/postgis:14-3.2 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends postgis

FROM  postgis/postgis:14-3.2
LABEL Author "Miguel Martinez <martinezpmg9@gmail.com>"

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
      wget unzip \
      && rm -rf /var/lib/apt/lists/* \
      && mkdir -p /docker-entrypoint-initdb.d

ENV POSTGIS_MAJOR=3.2

COPY --from=builder /usr/bin/shp2pgsql /usr/bin/shp2pgsql
COPY ./postgis.sh /docker-entrypoint-initdb.d/10_postgis.sh