ARG PDKIMAGE=puppet/pdk:3.0.0.0

FROM $PDKIMAGE

ARG SITE_MODULE_PATH=site_modules

RUN apt update
RUN apt --assume-yes install build-essential

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
