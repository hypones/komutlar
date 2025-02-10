#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Ubuntu 20.04 LAMP Installation Script
# Run without sudo (as root or with sudo) - bash install_lamp.sh
# Script auto terminates on errors

export DEBIAN_FRONTEND=noninteractive

echo -e "\e[96m Adding PPA for Apache and PHP \e[39m"
# Adding the PPA repositories for Apache and PHP
sudo add-apt-repository -y ppa:ondrej/apache2
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update

echo -e "\e[96m Installing Apache2 \e[39m"
# Install Apache2 web server
sudo apt-get -y install apache2

INSTALL_PHP_VER=${1:-8.3}

echo -e "\e[96m Installing PHP - ${INSTALL_PHP_VER} \e[39m"
# Install PHP and necessary modules
sudo apt-get -y install "php${INSTALL_PHP_VER}-cli" "libapache2-mod-php${INSTALL_PHP_VER}"

# Installing common PHP extensions
sudo apt-get -y install curl zip unzip
echo -e "\e[96m Installing PHP extensions for ${INSTALL_PHP_VER} \e[39m"
sudo apt-get -y install php${INSTALL_PHP_VER}-curl php${INSTALL_PHP_VER}-ctype php${INSTALL_PHP_VER}-uuid \
php${INSTALL_PHP_VER}-pgsql php${INSTALL_PHP_VER}-sqlite3 php${INSTALL_PHP_VER}-gd \
php${INSTALL_PHP_VER}-imap php${INSTALL_PHP_VER}-mysql php${INSTALL_PHP_VER}-mbstring php${INSTALL_PHP_VER}-iconv \
php${INSTALL_PHP_VER}-xml php${INSTALL_PHP_VER}-zip php${INSTALL_PHP_VER}-bcmath php${INSTALL_PHP_VER}-soap php${INSTALL_PHP_VER}-gettext \
php${INSTALL_PHP_VER}-intl php${INSTALL_PHP_VER}-readline \
php${INSTALL_PHP_VER}-msgpack php${INSTALL_PHP_VER}-igbinary php${INSTALL_PHP_VER}-ldap \
php${INSTALL_PHP_VER}-redis php${INSTALL_PHP_VER}-grpc

# Enabling PHP module for Apache
sudo phpenmod curl

# Enable Apache modules
echo -e "\e[96m Enabling Apache modules \e[39m"
sudo a2enmod rewrite
sudo a2enmod ssl
sudo a2enmod headers
sudo a2enmod "php${INSTALL_PHP_VER}"

echo -e "\e[96m Restarting Apache server to apply changes \e[39m"
# Restart Apache to reflect all changes
sudo service apache2 restart

# Install Composer (PHP dependency manager)
echo -e "\e[96m Installing Composer \e[39m"
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --force --filename=composer

# Fix permissions for Composer directory
mkdir -p ~/.composer
sudo chown -R "$USER" "$HOME/.composer"

echo -e "\e[96m Installing MySQL client and server \e[39m"
# Install MySQL client and server
sudo apt install -y mysql-client
sudo apt install -y mysql-server

# Check PHP version
php -v

# Check Apache version
apachectl -v

# Test PHP setup
php -r 'echo "\nYour PHP installation is working fine.\n";'

# Check Composer version
composer --version

# Final message
echo -e "\e[92m Open http://localhost/ to check if Apache is working \e[39m"

# Clean up package cache
sudo apt-get clean
