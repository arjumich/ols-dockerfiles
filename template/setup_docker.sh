#!/usr/bin/env bash
echo "listener HTTP {
  address                 *:8080
  secure                  0
}

listener HTTPS {
  address                 *:8443
  secure                  1
  keyFile                 /home/olsuser/lsws/admin/conf/webadmin.key
  certFile                /home/olsuser/lsws/admin/conf/webadmin.crt
}

vhTemplate docker {
  templateFile            conf/templates/docker.conf
  listeners               HTTP, HTTPS
  note                    docker

  member localhost {
    vhDomain              localhost, *
  }
}

" >> /home/olsuser/tmp/lsws/conf/httpd_config.conf

mkdir -p /var/www/vhosts/localhost/{html,logs,certs}
chown olsuser:olsuser /var/www/vhosts/localhost/ -R