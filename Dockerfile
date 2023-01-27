ARG PDKIMAGE=puppet/puppet-dev-tools:2023-01-11-8e11537

FROM $PDKIMAGE

ARG SITE_MODULE_PATH=site_modules

RUN gem install puppetfile-resolver

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
