#!/bin/bash

function install {
  dpkg -s $1 &>/dev/null 2>&1 && echo $1 already exists || {
    echo installing $1
    shift
    # apt-get -y install "$@" >/dev/null 2>&1
    apt-get -y install "$@"
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

install Dependencies git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libxml2 libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev libncurses5-dev libxft-dev chrpath 
install Dependencies libfreetype6 libfreetype6-dev
install Dependencies libfontconfig1 libfontconfig1-dev libgconf-2-4

# install PhantomJS phantomjs

echo installing PhantomJS v2.1.1
# cd ~
wget https://github.com/Medium/phantomjs/releases/download/v2.1.1/phantomjs-2.1.1-linux-x86_64.tar.bz2 >/dev/null 2>&1
sudo tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 >/dev/null 2>&1
sudo mv phantomjs-2.1.1-linux-x86_64 /usr/local/share >/dev/null 2>&1
sudo ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin

# echo installing Chromedriver
# wget -N http://chromedriver.storage.googleapis.com/2.10/chromedriver_linux64.zip -P ~/Downloads >/dev/null 2>&1
# unzip ~/Downloads/chromedriver_linux64.zip -d ~/Downloads >/dev/null 2>&1
# chmod +x ~/Downloads/chromedriver
# sudo mv -f ~/Downloads/chromedriver /usr/local/share/chromedriver
# sudo ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver
# sudo ln -s /usr/local/share/chromedriver /usr/bin/chromedriver

echo installing Ruby
apt-get install -y Ruby ruby2.3 ruby2.3-dev
update-alternatives --set ruby /usr/bin/ruby2.3
update-alternatives --set gem /usr/bin/gem2.3

type rails >/dev/null 2>&1 && echo "Rails already exists" || {
  echo installing Rails
  gem install rails -v 4.2.6 --no-ri --no-doc
}

type rails-api >/dev/null 2>&1 && echo "Rails-API already exists" || {
  echo installing Rails-API
  gem install rails-api
}

echo installing Bundler
gem install bundler --no-ri --no-doc

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - >/dev/null 2>&1
install NodeJs nodejs

install ImageMagick imagemagick

type bower >/dev/null 2>&1 && echo "Bower already exists" || {
  echo installing Bower
  npm install bower -g
}

type gulp >/dev/null 2>&1 && echo "Gulp already exists" || {
  echo installing Gulp
  npm install gulp -g
}

install SQLite sqlite3 libsqlite3-dev

type psql >/dev/null 2>&1 && echo "PostgreSQL already exists" || {
  install PostgreSQL postgresql postgresql-contrib libpq-dev
  sudo -u postgres createuser --superuser vagrant
  sudo -u postgres createdb -O vagrant activerecord_unittest
  sudo -u postgres createdb -O vagrant activerecord_unittest2
}

# type mongo >/dev/null 2>&1 && echo "MongoDB already exists" || {
#   echo installing MongoDB
#   apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 >/dev/null 2>&1
#   echo "deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list >/dev/null 2>&1
#   sudo apt-get update >/dev/null 2>&1
#   sudo apt-get install -y mongodb-org >/dev/null 2>&1
#   sudo mkdir -p /data/db >/dev/null 2>&1
#   sudo chown -R vagrant /data/db >/dev/null 2>&1
#   sudo apt-get -y install upstart-sysv >/dev/null 2>&1
# }

# Needed for docs generation.
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

# add environment variables
declare file="/etc/environment"
declare mask="POSTGRES"

declare file_content=$( cat "${file}" )
if [[ " $file_content " =~ $mask ]] # please note the space before and after the file content
  then
    echo "environment variables already set up"
  else
    echo "setting environment variables"
    echo POSTGRES_USER=vagrant >> /etc/environment
    # echo POSTGRES_PASSWORD=vagrant >> /etc/environment
    # echo POSTGRES_HOST=localhost >> /etc/environment
fi

echo "Let's rock!"
