FROM ubuntu:18.04

ARG OLS_VERSION=1.6.21
ARG PHP_VERSION=lsphp74


RUN apt-get update && apt-get install wget curl cron tzdata -y

RUN apt install sudo
RUN adduser --disabled-password --gecos '' --home "/home/olsuser" olsuser \
    && adduser olsuser sudo \
    && echo 'olsuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY openlitespeed.tgz /home/
RUN tar xzf /home/openlitespeed.tgz && cd openlitespeed && sed -i 's+/usr/local/lsws+/home/olsuser/tmp/lsws+g' ./ols.conf && ./install.sh && \
    echo 'cloud-docker' > /home/olsuser/tmp/lsws/PLAT && rm -rf /openlitespeed && rm /home/openlitespeed.tgz

#RUN chown olsuser:olsuser /home/olsuser/lsws/ -R
#RUN wget https://openlitespeed.org/preuse/openlitespeed-$OLS_VERSION.tgz && \
#    tar xzf openlitespeed-$OLS_VERSION.tgz && cd openlitespeed && ./install.sh && \
#    echo 'cloud-docker' > /usr/local/lsws/PLAT && rm -rf /openlitespeed && rm /openlitespeed-$OLS_VERSION.tgz

RUN apt-get install mysql-client $PHP_VERSION $PHP_VERSION-common $PHP_VERSION-mysql $PHP_VERSION-opcache \
    $PHP_VERSION-curl $PHP_VERSION-json $PHP_VERSION-imagick $PHP_VERSION-redis $PHP_VERSION-memcached $PHP_VERSION-intl -y

RUN wget -O /home/olsuser/tmp/lsws/admin/misc/lsup.sh \
    https://raw.githubusercontent.com/litespeedtech/openlitespeed/master/dist/admin/misc/lsup.sh && \
    chmod +x /home/olsuser/tmp/lsws/admin/misc/lsup.sh

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp && \
	ln -s /home/olsuser/tmp/lsws/$PHP_VERSION/bin/php /usr/bin/php

RUN wget -O -  https://get.acme.sh | sh

EXPOSE 8080

ADD docker.conf /home/olsuser/tmp/lsws/conf/templates/docker.conf
ADD setup_docker.sh /home/olsuser/tmp/lsws/bin/setup_docker.sh
ADD httpd_config.xml /home/olsuser/tmp/lsws/conf/httpd_config.xml
ADD htpasswd /home/olsuser/tmp/lsws/admin/conf/htpasswd

#RUN apt install sudo
#RUN adduser --disabled-password --gecos '' --home "/home/olsuser" olsuser \
#    && adduser olsuser sudo \
#    && echo 'olsuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN chown -R olsuser:olsuser /home/olsuser/tmp/lsws && chmod -R 777 /home/olsuser/tmp/lsws

RUN chmod 777 /home/olsuser/tmp/lsws/bin/lswsctrl
RUN chmod 777 /home/olsuser/tmp/lsws/bin/lswsctrl.open

#RUN ls -l /home/olsuser/tmp/lsws/bin/

RUN /home/olsuser/tmp/lsws/bin/setup_docker.sh && rm /home/olsuser/tmp/lsws/bin/setup_docker.sh
RUN ls -l /home/olsuser/tmp/lsws/bin/
RUN chown olsuser:olsuser /home/olsuser/tmp/lsws/conf -R
RUN cp -RP /home/olsuser/tmp/lsws/conf/ /home/olsuser/tmp/lsws/.conf/
RUN cp -RP /home/olsuser/tmp/lsws/admin/conf /home/olsuser/tmp/lsws/admin/.conf/
RUN ln -sf /home/olsuser/tmp/lsws/$PHP_VERSION/bin/lsphp /home/olsuser/tmp/lsws/fcgi-bin/lsphp7
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN chown olsuser:olsuser /var/www/vhosts -R
USER olsuser

ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /var/www/vhosts/
