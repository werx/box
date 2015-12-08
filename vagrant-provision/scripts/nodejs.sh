#!/usr/bin/env bash

# Test if NodeJS is installed
node -v > /dev/null 2>&1
NODE_IS_INSTALLED=$?

# Contains all arguments that are passed
NODE_ARG=($@)

# Number of arguments that are given
NUMBER_OF_ARG=${#NODE_ARG[@]}

# Prepare the variables for installing specific Nodejs version and Global Node Packages
if [[ $NUMBER_OF_ARG -gt 0 ]]; then
    # 1Global Node Packages are given
    NODE_PACKAGES=${NODE_ARG[@]:0}
fi

# True, if Node is not installed
if [[ $NODE_IS_INSTALLED -ne 0 ]]; then

    echo ">>> Installing Node Package Manager"

    sudo apt-get install -qq nodejs
	sudo ln -s /usr/bin/nodejs /usr/bin/node
	sudo apt-get install -qq npm

    # Update npm to latest.
    sudo npm install -g npm

    # Install NVM
    #curl --silent -L $GITHUB_URL/helpers/nvm_install.sh | sh

    # Re-source user profiles
    # if they exist
    if [[ -f "/home/vagrant/.profile" ]]; then
        . /home/vagrant/.profile
    fi
fi

# Install (optional) Global Node Packages
if [[ ! -z $NODE_PACKAGES ]]; then
    echo ">>> Start installing Global Node Packages"

    sudo npm install -g ${NODE_PACKAGES[@]}
fi
