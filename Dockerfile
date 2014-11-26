FROM ubuntu-debootstrap:latest
MAINTAINER Christian Lück <christian@lueck.tv>

RUN apt-get update && apt-get install nginx php5-fpm php5-cli supervisor curl unzip -y --no-install-recommends

RUN curl -O http://iweb.dl.sourceforge.net/project/phpvirtualbox/phpvirtualbox-4.3-1.zip && \
	unzip phpvirtualbox-4.3-1.zip && \
	mv phpvirtualbox-4.3-1 /var/www && \
	rm phpvirtualbox-4.3-1.zip

ADD config.php /var/www/
ADD servers-from-env.php /var/www/
ADD supervisord.conf /etc/
ADD phpvirtualbox.nginx.conf /etc/nginx/sites-enabled/default

RUN echo "<?php return array(); ?>" > /var/www/config-servers.php
RUN chown -R www-data:www-data /var/www
EXPOSE 80
CMD /usr/bin/php /var/www/servers-from-env.php && supervisord