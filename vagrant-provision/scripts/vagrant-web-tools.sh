#!/usr/bin/env bash

echo ">>> Installing Vagrant Tools"

# Test if Apache is installed
apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

if [[ $APACHE_IS_INSTALLED -eq 0 ]]; then
    #Apache configuration

    if [[ -e /usr/share/vagrant-web-tools ]]; then
        sudo rm -rf /usr/share/vagrant-web-tools
    fi

    sudo mkdir /usr/share/vagrant-web-tools
    sudo cp /home/vagrant/vagrant-web-tools.php /usr/share/vagrant-web-tools/index.php
    sudo tee /etc/apache2/conf-available/vagrant-tools.conf <<EOL
Alias /vagrant-tools /usr/share/vagrant-web-tools

<Directory /usr/share/vagrant-web-tools/html>
        Options FollowSymLinks
        DirectoryIndex index.php

        <IfModule mod_php5.c>
                AddType application/x-httpd-php .php

                php_flag magic_quotes_gpc Off
                php_flag track_vars On
                php_flag register_globals Off
                php_value include_path .
        </IfModule>
</Directory>
EOL

    sudo a2enconf vagrant-tools.conf
    sudo service apache2 reload
else
    echo "Apache must be installed to use Vagrant Web Tools"
fi
