#!/bin/bash

# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.

function install {
  dpkg -s $1 &>/dev/null 2>&1  && echo $1 already exists || {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
  }
}

if free | awk '/^Swap:/ {exit !$2}'; then
  echo "Swap is already enabled"
else
  echo adding swap file
  fallocate -l 2G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap defaults 0 0' >> /etc/fstab
fi

echo updating package information
apt-add-repository -y ppa:brightbox/ruby-ng >/dev/null 2>&1
apt-get -y update >/dev/null 2>&1

install Dependencies git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libxml2 libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev libncurses5-dev

echo installing Ruby
apt-get install Ruby ruby2.3 ruby2.3-dev >/dev/null 2>&1
update-alternatives --set ruby /usr/bin/ruby2.3 >/dev/null 2>&1
update-alternatives --set gem /usr/bin/gem2.3 >/dev/null 2>&1

echo installing Rails
gem install rails -v 4.2.6 --no-ri --no-doc >/dev/null 2>&1

echo installing Rails-API
gem install rails-api >/dev/null 2>&1

echo installing Bundler
gem install bundler --no-ri --no-doc >/dev/null 2>&1

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - >/dev/null 2>&1
install NodeJs nodejs
install NPM npm

install ImageMagic imagemagick

echo installing Bower
npm install bower -g >/dev/null 2>&1

echo installing Gulp
npm install gulp -g >/dev/null 2>&1

type psql >/dev/null 2>&1 && echo "PostgreSQL already exists" || {
  install PostgreSQL postgresql postgresql-contrib libpq-dev
  sudo -u postgres createuser --superuser vagrant
  sudo -u postgres createdb -O vagrant activerecord_unittest
  sudo -u postgres createdb -O vagrant activerecord_unittest2  
}

# Needed for docs generation.
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo "Let's rock!"
