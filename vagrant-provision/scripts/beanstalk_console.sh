#!/usr/bin/env bash

echo ">>> Installing Beanstalk Console"

# Test if Apache is installed
apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

if [[ $APACHE_IS_INSTALLED -eq 0 ]]; then
    # Install beanstalk console.

    if [[ -e /usr/share/beanstalk-console ]]; then
        sudo rm -rf /usr/share/beanstalk-console
    fi

    composer create-project ptrofimov/beanstalk_console -s dev /usr/share/beanstalk-console

    #Apache configuration
    sudo tee /etc/apache2/conf-available/beanstalk-console.conf <<EOL
Alias /beanstalk-console /usr/share/beanstalk-console/public

<Directory /usr/share/beanstalk-console/public>
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

#     sudo tee /usr/share/beanstalk-console/config.php <<STORAGE
# <?php
#
# \$GLOBALS['config'] = array(
#     /**
#      * List of servers available for all users
#      */
#     'servers' => array(/* 'Local Beanstalkd' => 'beanstalk://localhost:11300', ... */),
#     /**
#      * Saved samples jobs are kept in this file, must be writable
#      */
#     'storage' => '/home/vagrant/beanstalk-console-storage.json',
#     /**
#      * Optional Basic Authentication
#      */
#     'auth' => array(
#         'enabled' => false,
#         'username' => 'admin',
#         'password' => 'password',
#     ),
#     /**
#      * Version number
#      */
#     'version' => '1.7.4',
# );
# STORAGE

    sudo a2enconf beanstalk-console.conf
    sudo service apache2 reload

    # Make the storage file writable.
    sudo chown -R www-data:www-data /usr/share/beanstalk-console
    sudo chmod -R u+w /usr/share/beanstalk-console
else
    echo "Apache must be installed to use Beanstalk Console"
fi
