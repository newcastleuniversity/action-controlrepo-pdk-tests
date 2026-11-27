#! /usr/bin/env bash

CONTROLREPO_ROOT="$(pwd)"
SITE_ROOT="${CONTROLREPO_ROOT}/${SITE_MODULE_PATH}"

echo "=== SITE_ROOT ==="
echo $SITE_ROOT

if [ -n "$PUPPET_VERSION" ]; then
  additional_opts="--puppet-version $PUPPET_VERSION"
elif [ -n "$PE_VERSION" ]; then
  additional_opts="--pe-version $PE_VERSION"
else
  additional_opts=""
fi

export FACTERDB_SEARCH_PATHS=$(pwd)/facts

echo "=== ENVIRONMENT ==="
env | sort

echo "=== OPENSSL ==="
openssl version -a

echo "=== RUBY OPENSSL ==="
/opt/puppetlabs/pdk/private/ruby/2.7.7/bin/ruby -ropenssl -e 'puts OpenSSL::OPENSSL_VERSION'

echo "=== KERNEL ==="
uname -a

echo "PDK:"
pdk --version

echo "Ruby:"
ruby --version

echo "Puppet:"
puppet --version

echo "\nPuppet long path /opt/puppetlabs/pdk/private/puppet/ruby/2.7.0/bin/puppet --version:"
/opt/puppetlabs/pdk/private/puppet/ruby/2.7.0/bin/puppet \
  --version
echo "\nRuby long path /opt/puppetlabs/pdk/private/ruby/2.7.7/bin/ruby require puppet gem:"
/opt/puppetlabs/pdk/private/ruby/2.7.7/bin/ruby \
  -e 'require "puppet"'

echo "\nCopilot's suggested test thing:"
/opt/puppetlabs/pdk/private/ruby/2.7.7/bin/ruby \
  -ropenssl \
  -e 'p OpenSSL::SSL::SSLContext::DEFAULT_PARAMS.frozen?'

/opt/puppetlabs/pdk/private/ruby/2.7.7/bin/ruby \
  -ropenssl \
  -e 'p OpenSSL::SSL::SSLContext::DEFAULT_PARAMS'

echo "\nWhich PDK"  
which pdk

head -20 "$(which pdk)"

echo "\nFind ruby"
find /opt/puppetlabs/pdk -name ruby -type f
echo "\nFind puppet"
find /opt/puppetlabs/pdk -name puppet -type f

echo ""
echo 'Test require "puppet"; puts Puppet.version'
/opt/puppetlabs/pdk/private/ruby/2.7.7/bin/ruby \
  -I /opt/puppetlabs/pdk/private/puppet/ruby/2.7.0/gems/puppet-7.21.0/lib \
  -e 'require "puppet"; puts Puppet.version'

echo ""
echo "## gem list concurrent-ruby"  
/opt/puppetlabs/pdk/private/ruby/2.7.7/bin/gem list concurrent-ruby

echo "=== HOME ==="
ls -la /github/home

echo "=== PDK ==="
find /github/home/.pdk 2>/dev/null

cd "$SITE_ROOT/profiles"

echo "=== BUNDLER ==="
bundle check || true

echo "=== CONCURRENT RUBY ==="
bundle exec ruby -e 'require "concurrent"; puts Concurrent::VERSION' || true

echo "=== BUNDLE PUPPET ==="
bundle exec ruby -e 'require "puppet"; puts Puppet.version' || true

echo "-= Now deleting cached pdk and gems =-"

rm -rf /github/home/.pdk
rm -rf /github/home/.bundle

cd "$SITE_ROOT/profiles"

echo "=== GEM ENV ==="
bundle env || true

echo "=== BUNDLE CHECK ==="
bundle check || true

echo "=== BUNDLE LIST PUPPET ==="
bundle list | grep puppet || true

cd "$SITE_ROOT"

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
