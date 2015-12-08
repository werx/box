#!/usr/bin/env bash

echo ">>> Installing SQLite Server"

# Install SQLite
# -qq implies -y --force-yes
sudo apt-get install -qq sqlite
