FROM ubuntu:18.04

ARG OLS_VERSION
ARG PHP_VERSION

ENV SERVERRROOT=/home/olsuser/tmp/lsws

RUN apt-get update && apt-get install wget curl cron tzdata -y

RUN adduser --disabled-password --gecos '' --home "/home/olsuser" olsuser

COPY openlitespeed.tgz /home/
RUN tar xzf /home/openlitespeed.tgz && cd openlitespeed && sed -i 's+/usr/local/lsws+/home/olsuser/tmp/lsws+g' ./ols.conf && ./install.sh && \
    echo 'cloud-docker' > $SERVERRROOT/PLAT && rm -rf /openlitespeed && rm /home/openlitespeed.tgz

## use the following when downloading openlitespeed installation file instead of using local tar file

#RUN wget https://openlitespeed.org/preuse/openlitespeed-$OLS_VERSION.tgz && \
#    tar xzf openlitespeed-$OLS_VERSION.tgz && cd openlitespeed && ./install.sh && \
#    echo 'cloud-docker' > $SERVERRROOT/PLAT && rm -rf /openlitespeed && rm /openlitespeed-$OLS_VERSION.tgz

RUN apt-get install mysql-client $PHP_VERSION $PHP_VERSION-common $PHP_VERSION-mysql $PHP_VERSION-opcache \
    $PHP_VERSION-curl $PHP_VERSION-json $PHP_VERSION-imagick $PHP_VERSION-redis $PHP_VERSION-memcached $PHP_VERSION-intl -y

RUN wget -O $SERVERRROOT/admin/misc/lsup.sh \
    https://raw.githubusercontent.com/litespeedtech/openlitespeed/master/dist/admin/misc/lsup.sh && \
    chmod +x $SERVERRROOT/admin/misc/lsup.sh

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp && \
	ln -s /usr/local/lsws/$PHP_VERSION/bin/php /usr/bin/php
#not replacing with #SERVERROOT as the installation path for php is still /usr/local/lsws

RUN wget -O -  https://get.acme.sh | sh

EXPOSE 8080
EXPOSE 7080
#port 7080 is for admin console 

ADD docker.conf $SERVERRROOT/conf/templates/docker.conf
ADD setup_docker.sh $SERVERRROOT/bin/setup_docker.sh
ADD httpd_config.xml $SERVERRROOT/conf/httpd_config.xml
ADD htpasswd $SERVERRROOT/admin/conf/htpasswd

RUN chown -R olsuser:olsuser $SERVERRROOT && chmod -R 777 $SERVERRROOT

RUN chmod 777 $SERVERRROOT/bin/lswsctrl
RUN chmod 777 $SERVERRROOT/bin/lswsctrl.open

RUN $SERVERRROOT/bin/setup_docker.sh && rm $SERVERRROOT/bin/setup_docker.sh
RUN chown olsuser:olsuser $SERVERRROOT/conf -R
RUN cp -RP $SERVERRROOT/conf/ $SERVERRROOT/.conf/
RUN cp -RP $SERVERRROOT/admin/conf $SERVERRROOT/admin/.conf/
RUN ln -sf /usr/local/lsws/$PHP_VERSION/bin/lsphp $SERVERRROOT/fcgi-bin/lsphp5
#not replacing with #SERVERROOT as the installation path for php is still /usr/local/lsws
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN chown olsuser:olsuser /var/www/vhosts -R
USER olsuser

ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /var/www/vhosts/

RUN echo '<?php phpinfo();' > localhost/html/index.php