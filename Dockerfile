ARG PDKIMAGE=puppet/puppet-dev-tools:2025-01-27-d09e323

FROM $PDKIMAGE

ARG SITE_MODULE_PATH=site_modules

RUN gem install puppetfile-resolver

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
