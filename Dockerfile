# FROM ubuntu:18.04
FROM perl:5.32.0-buster

# The default setup sends access logs to STDOUT, and poet logs to appdir/logs

# docker run -d --rm --init --env UID="$(id -u "$USER")" --env GID="$(id -g "$USER")" -p 5000:5000 poet-mason

COPY cpanfile entrypoint /

RUN cpanm --notest --no-man-pages --installdeps . && rm -rf /root/.cpanm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -y --no-install-recommends install gosu \
 && apt-get -y autoclean \
 && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*

EXPOSE 5000

ENV UID GID

WORKDIR /srv

RUN poet new MasonApp

ENTRYPOINT ["/entrypoint"]

CMD [ "/srv/mason_app/bin/run.pl" ]
