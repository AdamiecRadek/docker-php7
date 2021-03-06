#INSTALL FROM FAVORITE DISTRO
FROM ubuntu:trusty

#INSTALL DEPENDENCIES
RUN  apt-get update &&  apt-get install -y --force-yes mcrypt mc git zip unzip curl \
     build-essential autoconf bison bzip2 libbz2-dev libjpeg8-dev libXpm-dev postgresql-server-dev-all libxml2-dev \
     pkg-config libcurl4-openssl-dev libpng-dev libfreetype6-dev libgmp-dev  libgmp3-dev libmcrypt-dev libmysqlclient15-dev \
     libpspell-dev librecode-dev  wget

#SMALL FIX FOR MISSING LIBS
RUN  ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h

#GET
RUN  git clone --depth=1 https://git.php.net/repository/php-src.git /usr/local/php7

#BUILD IT
RUN  cd /usr/local/php7 && ./buildconf
RUN  cd /usr/local/php7 && ./configure --prefix=/usr/local/php7 --with-config-file-path=/etc --enable-mbstring --enable-zip --enable-bcmath --enable-pcntl --enable-ftp --enable-exif --enable-calendar --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-wddx --with-curl --with-mcrypt --with-iconv --with-gmp --with-pspell --with-gd --with-jpeg-dir=/usr --with-png-dir=/usr --with-zlib-dir=/usr --with-xpm-dir=/usr --with-freetype-dir=/usr  --enable-gd-native-ttf --enable-gd-jis-conv --with-openssl --with-pdo-mysql=/usr --with-gettext=/usr --with-zlib=/usr --with-bz2=/usr --with-recode=/usr --with-mysqli=/usr/bin/mysql_config --with-pgsql --enable-fpm --with-pdo-pgsql --with-fpm-user=www-data --with-fpm-group=www-data
RUN  cd /usr/local/php7 && make
RUN  cd /usr/local/php7 && make install

#CONFIGURE PHP7
RUN  cp /usr/local/php7/etc/php-fpm.conf.default /usr/local/php7/etc/php-fpm.conf
RUN  cp /usr/local/php7/etc/php-fpm.d/www.conf.default /usr/local/php7/etc/php-fpm.d/www.conf
RUN  ln -s /usr/local/php7/sapi/cli/php /usr/bin/php
RUN  wget https://raw.githubusercontent.com/AdamiecRadek/docker-php7/master/php-fpm -O /etc/init.d/php-fpm
RUN  chmod 755 /etc/init.d/php-fpm
RUN  wget https://raw.githubusercontent.com/AdamiecRadek/docker-php7/master/php-fpm.service -O /lib/systemd/system/php-fpm.service
RUN  /etc/init.d/php-fpm start
RUN  update-rc.d php-fpm defaults

#OPEN THE GATES
EXPOSE 9000
