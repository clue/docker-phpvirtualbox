FROM ubuntu
MAINTAINER Christian Lück <christian@lueck.tv>

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  nginx php5-fpm supervisor openssh-client \
  wget unzip

# install phpvirtualbox
RUN wget http://sourceforge.net/projects/phpvirtualbox/files/phpvirtualbox-4.3-1.zip/download -O phpvirtualbox-4.3-1.zip
RUN unzip phpvirtualbox-4.3-1.zip
RUN mv phpvirtualbox-4.3-1 /var/www
ADD config.php /var/www/config.php
RUN chown www-data:www-data -R /var/www

# add phpvirtualbox as the only nginx site
ADD phpvirtualbox.nginx.conf /etc/nginx/sites-available/phpvirtualbox
RUN ln -s /etc/nginx/sites-available/phpvirtualbox /etc/nginx/sites-enabled/phpvirtualbox
RUN rm /etc/nginx/sites-enabled/default

WORKDIR /var/www

# use supervisor to monitor all services
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf

# expose only nginx HTTP port
EXPOSE 80

