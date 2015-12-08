#!/usr/bin/env bash

echo ">>> Installing Redis"

# Install Redis
sudo apt-get install -qq redis-server
mv /etc/redis/redis.conf /etc/redis/redis.conf.old
echo "bind 0.0.0.0" | tee /etc/redis/redis.conf
cat /etc/redis/redis.conf.old | grep -v bind | tee -a /etc/redis/redis.conf
service redis-server restart
