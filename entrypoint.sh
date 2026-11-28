#! /usr/bin/env bash

SITE_ROOT="$(pwd)/$SITE_MODULE_PATH"

echo $PUPPET_VERSION

if [[ -v PUPPET_VERSION ]] ; then
  PDK_OPTIONS+=" --puppet-version=$PUPPET_VERSION"
fi

echo "+-------------------+"
echo "| Test the profiles |"
echo "+-------------------+"
(cd $SITE_ROOT/profiles ; pdk validate --format=text $PDK_OPTIONS) || exit 1
(cd $SITE_ROOT/profiles ; pdk test unit --format=text $PDK_OPTIONS) || exit 1
echo ""
echo "+----------------+"
echo "| Test the roles |"
echo "+----------------+"
(cd $SITE_ROOT/roles ; pdk validate --format=text $PDK_OPTIONS) || exit 1
(cd $SITE_ROOT/roles ; pdk test unit --format=text $PDK_OPTIONS) || exit 1
