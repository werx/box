#!/usr/bin/env bash

echo ">>> Installing Adminer"

# Test if Apache is installed
apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

if [[ $APACHE_IS_INSTALLED -eq 0 ]]; then
    # Install Adminer
    sudo mkdir /usr/share/adminer
    sudo wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/latest.php
    sudo ln -s /usr/share/adminer/latest.php /usr/share/adminer/adminer.php
    echo "Alias /adminer.php /usr/share/adminer/adminer.php" | sudo tee /etc/apache2/conf-available/adminer.conf
    sudo a2enconf adminer.conf

    sudo service apache2 reload
else
    echo "Apache must be installed to use Adminer"
fi
