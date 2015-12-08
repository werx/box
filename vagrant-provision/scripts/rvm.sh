#!/usr/bin/env bash

# Check if RVM is installed
RVM -v > /dev/null 2>&1
RVM_IS_INSTALLED=$?

# Contains all arguments that are passed
RUBY_ARG=($@)

# Number of arguments that are given
NUMBER_OF_ARG=${#RUBY_ARG[@]}

# Prepare the variables for installing specific Ruby version and Gems
if [[ $NUMBER_OF_ARG -gt 0 ]]; then
    RUBY_GEMS=${RUBY_ARG[@]:1}
fi

if [[ $RVM_IS_INSTALLED -eq 0 ]]; then
    echo ">>> Updating Ruby Version Manager"
    rvm get stable --ignore-dotfiles
else
    # Import Michal Papis' key to be able to verify the installation
    echo ">>> Importing rvm public key"
    gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3

    # Install RVM and install latest stable Ruby version
    \curl -sSL https://get.rvm.io | bash -s stable --ruby

    # Re-source RVM
    . /home/vagrant/.rvm/scripts/rvm

    # Re-source .profile if exists
    if [[ -f "/home/vagrant/.profile" ]]; then
        . /home/vagrant/.profile
    fi
fi

# Install (optional) Ruby Gems
if [[ ! -z $RUBY_GEMS ]]; then
    echo ">>> Start installing Ruby Gems"
    gem install ${RUBY_GEMS[@]}
fi
