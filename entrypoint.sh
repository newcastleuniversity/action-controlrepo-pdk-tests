#! /usr/bin/env bash

if [ -n "$PUPPET_VERSION" ]; then
  additional_opts="--puppet-version $PUPPET_VERSION"
elif [ -n "$PE_VERSION" ]; then
  additional_opts="--pe-version $PE_VERSION"
else
  additional_opts=""
fi

export FACTERDB_SEARCH_PATHS=$(pwd)/facts

echo ""
echo "+---------------------------+"
echo "| Test the site.pp manifest |"
echo "+---------------------------+"
puppet parser validate manifests/site.pp || return 1
echo ""
echo "+-------------------------------+"
echo "| Check Puppetfile dependencies |"
echo "+-------------------------------+"
ruby puppetfile-resolver.rb
echo ""
echo "+-------------------+"
echo "| Test the profiles |"
echo "+-------------------+"
(cd $SITE_MODULE_PATH/profiles ; pdk validate --format=text $additional_opts) || return 1
(cd $SITE_MODULE_PATH/profiles ; pdk test unit --format=text $additional_opts) || return 1
echo ""
echo "+----------------+"
echo "| Test the roles |"
echo "+----------------+"
(cd $SITE_MODULE_PATH/roles ; pdk validate --format=text $additional_opts) || return 1
(cd $SITE_MODULE_PATH/roles ; pdk test unit --format=text $additional_opts) || return 1
