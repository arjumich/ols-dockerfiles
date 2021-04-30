FROM ubuntu:18.04

ARG OLS_VERSION=1.6.21
ARG PHP_VERSION=lsphp74


RUN apt-get update && apt-get install wget curl cron tzdata -y

RUN apt install sudo
RUN adduser --disabled-password --gecos '' --home "/home/olsuser" olsuser \
    && adduser olsuser sudo \
    && echo 'olsuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY openlitespeed.tgz /home/
RUN tar xzf /home/openlitespeed.tgz && cd openlitespeed && sed -i 's+/usr/local/lsws+/home/olsuser/lsws+g' ./ols.conf && ./install.sh && \
    echo 'cloud-docker' > /home/olsuser/lsws/PLAT && rm -rf /openlitespeed && rm /home/openlitespeed.tgz

#RUN chown olsuser:olsuser /home/olsuser/lsws/ -R
#RUN wget https://openlitespeed.org/preuse/openlitespeed-$OLS_VERSION.tgz && \
#    tar xzf openlitespeed-$OLS_VERSION.tgz && cd openlitespeed && ./install.sh && \
#    echo 'cloud-docker' > /usr/local/lsws/PLAT && rm -rf /openlitespeed && rm /openlitespeed-$OLS_VERSION.tgz
RUN ls -l /home/olsuser/lsws/conf/

RUN apt-get install mysql-client $PHP_VERSION $PHP_VERSION-common $PHP_VERSION-mysql $PHP_VERSION-opcache \
    $PHP_VERSION-curl $PHP_VERSION-json $PHP_VERSION-imagick $PHP_VERSION-redis $PHP_VERSION-memcached $PHP_VERSION-intl -y

RUN wget -O /home/olsuser/lsws/admin/misc/lsup.sh \
    https://raw.githubusercontent.com/litespeedtech/openlitespeed/master/dist/admin/misc/lsup.sh && \
    chmod +x /home/olsuser/lsws/admin/misc/lsup.sh

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp && \
	ln -s /home/olsuser/lsws/$PHP_VERSION/bin/php /usr/bin/php

RUN wget -O -  https://get.acme.sh | sh

EXPOSE 7080

ADD docker.conf /home/olsuser/lsws/conf/templates/docker.conf
ADD setup_docker.sh /home/olsuser/lsws/bin/setup_docker.sh
ADD httpd_config.xml /home/olsuser/lsws/conf/httpd_config.xml
ADD htpasswd /home/olsuser/lsws/admin/conf/htpasswd

#RUN apt install sudo
#RUN adduser --disabled-password --gecos '' --home "/home/olsuser" olsuser \
#    && adduser olsuser sudo \
#    && echo 'olsuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN chown olsuser:olsuser /home/olsuser/lsws/ -R

RUN /home/olsuser/lsws/bin/setup_docker.sh && rm /home/olsuser/lsws/bin/setup_docker.sh
RUN chown olsuser:olsuser /home/olsuser/lsws/conf -R
RUN cp -RP /home/olsuser/lsws/conf/ /home/olsuser/lsws/.conf/
RUN cp -RP /home/olsuser/lsws/admin/conf /home/olsuser/lsws/admin/.conf/
RUN ln -sf /home/olsuser/lsws/$PHP_VERSION/bin/lsphp /home/olsuser/lsws/fcgi-bin/lsphp7
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN chown olsuser:olsuser /var/www/vhosts -R
USER olsuser

ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /var/www/vhosts/
