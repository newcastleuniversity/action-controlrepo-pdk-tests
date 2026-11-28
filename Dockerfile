ARG PDKIMAGE=puppet/pdk:3.0.0.0

FROM $PDKIMAGE

ARG SITE_MODULE_PATH=site_modules

RUN apt update
RUN apt install build-essential

RUN gem install puppetfile-resolver

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
