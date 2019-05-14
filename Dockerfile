FROM goaldriven/alpine-ols-php-app

# Install required WordPress php extensions
RUN apk add --no-cache php7.3-pdo php7.3-pdo_mysql php7.3-mysqli

# Cleanup document root
RUN rm -rf /var/lib/litespeed/web/ && mkdir -p /var/lib/litespeed/web/

# Copy wordpress file
RUN mkdir -p /var/lib/litespeed/web/
COPY wordpress/ /var/lib/litespeed/web/
RUN ln -s /var/lib/litespeed/web/web/ /var/lib/litespeed/web/html
RUN chown -R lsadm:lsadm /var/lib/litespeed/web/

# Copy vhost config file
RUN rm -f /var/lib/litespeed/conf/vhosts/web/vhconf.conf
ADD var/lib/litespeed/conf/vhosts/web/vhconf.conf /var/lib/litespeed/conf/vhosts/web/vhconf.conf

WORKDIR /var/lib/litespeed/web/

RUN apk upgrade && /var/lib/litespeed/bin/lswsctrl restart && composer install

EXPOSE 80 443 7080