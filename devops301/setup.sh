#!/usr/bin/env bash

## Become root (Avoid this in production)
sudo su

## Update the system
apt update

## Install the required packages
apt install -y apache2 memcached ssl-cert libapache2-mod-wsgi python-pip

## Install flask
pip install flask

## Executable permission to scripts
chmod u+x /vagrant/cronjob/exercise-memcached.sh /vagrant/cronjob/get_set_key.sh

## Sync required folders
if ! [ -L /var/www ]; then
    rm -rf /var/www
    ln -fs /vagrant/www /var/www
fi

if ! [ -L /etc/apache2/sites-enabled ]; then
    rm -rf /etc/apache2/sites-available /etc/apache2/sites-enabled
    ln -fs /vagrant/sites-enabled /etc/apache2/sites-enabled
fi

if ! [ -L /home/vagrant/exercise-memcache.sh ]; then
    ln -fs /vagrant/cronjob/exercise-memcached.sh /home/vagrant/exercise-memcache.sh
fi

ln -fs /vagrant/cronjob/get_set_key.sh /home/vagrant/get_set_key.sh
cp /vagrant/cronjob/memcached-cron /etc/cron.d/memcached-cron

## Enable apache modules for SSL redirects
sudo a2enmod ssl wsgi

## Restart apache to reflect the changes
sudo service apache2 restart
