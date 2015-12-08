#!/usr/bin/env bash

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

echo ">>> Installing Apache Server"

[[ -z $1 ]] && { echo "!!! IP address not set. Check the Vagrant file."; exit 1; }

if [[ -z $2 ]]; then
    public_folder="/web"
else
    public_folder="$2"
fi

# Add repo for latest FULL stable Apache
# (Required to remove conflicts with PHP PPA due to partial Apache upgrade within it)
sudo add-apt-repository -y ppa:ondrej/apache2


# Update Again
sudo apt-key update
sudo apt-get update

# Install Apache
# -qq implies -y --force-yes
sudo apt-get install -qq apache2 libapache2-mod-php5

echo ">>> Configuring Apache"

# Add vagrant user to www-data group
sudo usermod -a -G www-data vagrant

# Apache Config
# On separate lines since some may cause an error
# if not installed
#sudo a2dismod mpm_prefork mpm_worker
#sudo a2dismod php5
#sudo a2enmod mpm_prefork mpm_worker rewrite actions ssl php5
sudo a2enmod mpm_prefork rewrite actions ssl php5

# Create a virtualhost to start, with SSL certificate
sudo vhost -s $1.xip.io -a $1 -d /var/www$public_folder -p /etc/ssl/xip.io -c xip.io -a $3
sudo a2dissite 000-default
sudo service apache2 restart
