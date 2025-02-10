#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Ubuntu 20.04 LAMP Server Kurulumu
# Çalıştırma: bash install_lamp_ubuntu20.sh
# Bu betik, hata durumunda otomatik olarak duracaktır.

export DEBIAN_FRONTEND=noninteractive

echo -e "\e[96m PPA Depoları Ekleniyor  \e[39m"
sudo add-apt-repository -y ppa:ondrej/apache2
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update

echo -e "\e[96m Apache Kuruluyor  \e[39m"
sudo apt-get -y install apache2

INSTALL_PHP_VER=${1:-8.3}

echo -e "\e[96m PHP 8.3 Kuruluyor \e[39m"
sudo apt-get -y install "php8.3-cli" "libapache2-mod-php8.3"

sudo apt-get -y install curl zip unzip

echo -e "\e[96m PHP Uzantıları Kuruluyor \e[39m"
sudo apt-get -y install php8.3-cli php8.3-curl php8.3-ctype php8.3-uuid \
php8.3-pgsql php8.3-sqlite3 php8.3-gd \
php8.3-imap php8.3-mysql php8.3-mbstring php8.3-iconv \
php8.3-xml php8.3-zip php8.3-bcmath php8.3-soap php8.3-gettext \
php8.3-intl php8.3-readline \
php8.3-msgpack php8.3-igbinary php8.3-ldap \
php8.3-redis php8.3-grpc

# Apache modülleri etkinleştiriliyor
sudo a2enmod rewrite
sudo a2enmod ssl
sudo a2enmod headers
sudo a2enmod "php8.3"

echo -e "\e[96m Apache Yeniden Başlatılıyor \e[39m"
sudo service apache2 restart

# Composer kurulumu
echo -e "\e[96m Composer Kuruluyor \e[39m"
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --force --filename=composer

# MySQL Kurulumu
echo -e "\e[96m MySQL İstemcisi Kuruluyor \e[39m"
sudo apt install -y mysql-client

echo -e "\e[96m MySQL Sunucusu Kuruluyor \e[39m"
sudo apt install -y mysql-server

# PHP ve Apache versiyon kontrolü
echo -e "\e[96m PHP Versiyon Kontrolü \e[39m"
php -v

echo -e "\e[96m Apache Versiyon Kontrolü \e[39m"
apachectl -v

echo -e "\e[96m PHP Çalışıyor mu Test Ediliyor \e[39m"
php -r 'echo "\nPHP kurulumu başarılı!\n";'

# Composer izinleri düzeltiliyor
mkdir -p ~/.composer
sudo chown -R "$USER" "$HOME/.composer"

# Composer versiyon kontrolü
echo -e "\e[96m Composer Versiyon Kontrolü \e[39m"
composer --version

echo -e "\e[92m Kurulum Tamamlandı! Apache'yi test etmek için: http://localhost/ \e[39m"

# Gereksiz dosyalar temizleniyor
sudo apt-get clean
