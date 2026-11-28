#! /usr/bin/env bash

echo "-= The entry directory =-"
pwd

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
