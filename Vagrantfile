# -*- mode: ruby -*-
# vi: set ft=ruby :
# https://github.com/fideloper/Vaprobash
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Server Configuration
HOSTNAME        = "app.werx"

# Set a local private network IP address.
# See http://en.wikipedia.org/wiki/Private_network for explanation
# You can use the following IP ranges:
#   10.0.0.1    - 10.255.255.254
#   172.16.0.1  - 172.31.255.254
#   192.168.0.1 - 192.168.255.254
SERVER_IP             = "192.168.22.10"
SERVER_CPUS           = "2"   # Cores
SERVER_MEMORY         = "1024" # MB
SERVER_SWAP           = "1024" # Options: false | int (MB) - Guideline: Between one or two times the server_memory

# UTC        for Universal Coordinated Time
# EST        for Eastern Standard Time
# US/Central for American Central
# US/Eastern for American Eastern
SERVER_TIMEZONE  = "US/Central"

# Database Configuration
MYSQL_ROOT_PASSWORD   = "root"   # We'll assume user "root"
MYSQL_VERSION         = "5.5"    # Options: 5.5 | 5.6
MYSQL_ENABLE_REMOTE   = "true"  # remote access enabled when true
PGSQL_ROOT_PASSWORD   = "root"   # We'll assume user "root"

# Languages and Packages
PHP_TIMEZONE          = "UTC"    # http://php.net/manual/en/timezones.php
PHP_VERSION           = "5.6"     # Options: 5.5 | 5.6
RUBY_GEMS             = [        # List any Ruby Gems that you want to install
  #"jekyll",
  #"github-pages",
  #"sass",
  #"compass",
]

# PHP Options
COMPOSER_PACKAGES     = [        # List any global Composer packages that you want to install
  #"phpunit/phpunit:4.0.*",
  #"codeception/codeception=*",
  #"phpspec/phpspec:2.0.*@dev",
  #"squizlabs/php_codesniffer:1.5.*",
]

# Default web server document root
PUBLIC_FOLDER         = "/web"

#NODEJS_VERSION        = "latest"   # By default "latest" will equal the latest stable version
NODEJS_PACKAGES       = [          # List any global NodeJS packages that you want to install
  "grunt-cli",
  "gulp",
  "bower",
  #"yo",
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "ubuntu/trusty64"

    # Networking
    config.vm.network "private_network", ip: "#{SERVER_IP}"
    config.vm.hostname = "#{HOSTNAME}"

    # Forward host 8888 to guest 80 for apache
    config.vm.network "forwarded_port", guest: 80, host: 8888

    # Forward host 3307 to guest 3306 for mysql
    config.vm.network "forwarded_port", guest: 3306, host: 3307

    # Shared folder
    config.vm.synced_folder ".", "/var/www", :mount_options => ["dmode=777", "fmode=666"]

    config.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 2
      vb.name = "werxbox"
    end

    ####
    # Base config
    ##########
    config.vm.provision "shell", path: "./vagrant-provision/scripts/base.sh", args: [SERVER_SWAP, SERVER_TIMEZONE]

    # Vhost helper.
    config.vm.provision "file", source: "./vagrant-provision/bin/vhost", destination: "/home/vagrant/vhost"
    config.vm.provision "shell", inline: "sudo mv /home/vagrant/vhost /usr/local/bin/vhost; sudo chmod guo+x /usr/local/bin/vhost"

    # PHP
    config.vm.provision "file", source: "./vagrant-provision/customizations/php.ini", destination: "/home/vagrant/php.ini"
    config.vm.provision "shell", path: "./vagrant-provision/scripts/php.sh", args: [PHP_TIMEZONE, PHP_VERSION]

    # Provision Composer
    config.vm.provision "shell", path: "./vagrant-provision/scripts/composer.sh", privileged: false, args: [COMPOSER_PACKAGES.join(" ")]

    ####
    # Web Servers
    ##########

    # Provision Apache Base
    config.vm.provision "shell", path: "./vagrant-provision/scripts/apache.sh", args: [SERVER_IP, PUBLIC_FOLDER, HOSTNAME]

    # Custom apache rules
    config.vm.provision "file", source: "./vagrant-provision/customizations/apache.conf", destination: "/home/vagrant/apache.conf"
    config.vm.provision "shell", inline: "sudo mv /home/vagrant/apache.conf /etc/apache2/conf-available/vagrant-custom.conf; sudo a2enconf vagrant-custom; sudo service apache2 restart"

    ####
    # Databases
    ##########

    # Provision SQLite
    config.vm.provision "shell", path: "./vagrant-provision/scripts/sqlite.sh"

    # Provision MariaDB. You can install MySQL OR MariaDB, but not both.
    config.vm.provision "shell", path: "./vagrant-provision/scripts/mariadb.sh", args: [MYSQL_ROOT_PASSWORD, MYSQL_ENABLE_REMOTE]

    # Install Adminer GUI Database client. Will be available at http://192.168.22.10/adminer.php
    config.vm.provision "shell", path: "./vagrant-provision/scripts/adminer.sh"

    # Provision MySQL. You can install MySQL OR MariaDB, but not both.
    #config.vm.provision "shell", path: "./vagrant-provision/scripts/mysql.sh", args: [MYSQL_ROOT_PASSWORD, MYSQL_VERSION, MYSQL_ENABLE_REMOTE]

    # Provision PostgreSQL
    #config.vm.provision "shell", path: "./vagrant-provision/scripts/pgsql.sh", args: PGSQL_ROOT_PASSWORD

    ####
    # In-Memory Stores
    ##########

    # Install Memcached
    #config.vm.provision "shell", path: "./vagrant-provision/scripts/memcached.sh"

    # Provision Redis
    config.vm.provision "shell", path: "./vagrant-provision/scripts/redis.sh"

    ####
    # Utility (queue)
    ##########

    # Install Beanstalkd
    config.vm.provision "shell", path: "./vagrant-provision/scripts/beanstalkd.sh"

    # Install Beanstalk Console. Will be available at http://192.168.22.10/beanstalk-console/index.php
    config.vm.provision "shell", path: "./vagrant-provision/scripts/beanstalk_console.sh"

    # Install Supervisord
    #config.vm.provision "shell", path: "./vagrant-provision/scripts/supervisord.sh"

    ####
    # Additional Languages
    ##########

    # Install Nodejs
    config.vm.provision "shell", path: "./vagrant-provision/scripts/nodejs.sh", privileged: true, args: [NODEJS_PACKAGES.join(" ")]

    # Install Ruby Version Manager (RVM)
    config.vm.provision "shell", path: "./vagrant-provision/scripts/rvm.sh", privileged: false, args: [RUBY_GEMS.join(" ")]

    ####
    # Frameworks and Tooling
    ##########

    # Install Vagrant Web Tools Index. Will be available at http://192.168.22.10/vagrant-tools/
    config.vm.provision "file", source: "./vagrant-provision/vagrant-web-tools/index.php", destination: "/home/vagrant/vagrant-web-tools.php"
    config.vm.provision "shell", path: "./vagrant-provision/scripts/vagrant-web-tools.sh"

    # Install Mailcatcher. Will be available at http://192.168.22.10:1080
    config.vm.provision "shell", path: "./vagrant-provision/scripts/mailcatcher.sh"

    ####
    # Misc tools
    ##########

    # Install Image Magick
    config.vm.provision "shell", path: "./vagrant-provision/scripts/imagick.sh"

    ####
    # Run Always. Rebuilds with every vagrant up / vagrant reload
    ##########

    # CRON.
    config.vm.provision "file", source: "./vagrant-provision/customizations/crontab.txt", destination: "/home/vagrant/crontab.txt", run: "always"
    config.vm.provision "shell", privileged: false, inline: "crontab /home/vagrant/crontab.txt; echo \"Installed CRON\"; crontab -l", run: "always"

    # Custom shell script with any customizations you want.
    config.vm.provision "file", source: "./vagrant-provision/customizations/bash.sh", destination: "/home/vagrant/run-always.sh", run: "always"
    config.vm.provision "shell", inline: "sudo chmod a+x /home/vagrant/run-always.sh; /home/vagrant/run-always.sh", run: "always"
end
