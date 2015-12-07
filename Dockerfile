FROM debian:jessie
MAINTAINER Leigh Phillips <neurocis@qlustor.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  wget unzip supervisor \
  nginx php5-fpm php5-cli

ENV PHPVBOX_NAME phpvirtualbox-5.0-3

# install phpvirtualbox for 5.0
#RUN wget http://sourceforge.net/projects/phpvirtualbox/files/$PHPVBOX_NAME.zip/download -O /var/$PHPVBOX_NAME.zip && \
RUN wget http://www.mirrorservice.org/sites/downloads.sourceforge.net/p/ph/phpvirtualbox/$PHPVBOX_NAME.zip -O /var/$PHPVBOX_NAME.zip && \
    unzip /var/$PHPVBOX_NAME.zip -d /var && \
    mv /var/$PHPVBOX_NAME/* /var/www && \
    rm /var/$PHPVBOX_NAME.zip && \
    echo "<?php return array(); ?>" > /var/www/config-servers.php && \
    chown www-data:www-data -R /var/www
#    chown nginx:nginx -R /var/www
ADD config.php /var/www/config.php

# add phpvirtualbox as the only nginx site
ADD phpvirtualbox.nginx.conf /etc/nginx/sites-available/phpvirtualbox
RUN mkdir -p /etc/nginx/sites-enabled && \
    ln -s /etc/nginx/sites-available/phpvirtualbox /etc/nginx/sites-enabled/phpvirtualbox && \
    rm -f /etc/nginx/sites-enabled/default

# use supervisor to monitor all services
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# add startup script to write linked instances to server config
ADD servers-from-env.php /servers-from-env.php

# write linked instances to config, then monitor all services
CMD php /servers-from-env.php && \
  supervisord -c /etc/supervisor/conf.d/supervisord.conf

# expose only nginx HTTP port
EXPOSE 80

