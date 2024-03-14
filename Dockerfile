FROM docker.io/almalinux:9
WORKDIR /usr/share/nginx/html
COPY nginx-php-fpm /usr/local/sbin/
RUN dnf install http://rpms.remirepo.net/enterprise/remi-release-9.rpm -y \
    && dnf -y module install php:remi-7.4 \
    && dnf -y module install nginx \
    && dnf -y install php-zip php-intl php-mysqlnd php-dom php-simplexml \
    php-xml php-xmlreader php-curl php-exif php-ftp php-gd php-iconv procps-ng \
    php-json php-mbstring php-posix php-sockets php-tokenizer php-ldap \
    && mkdir /run/php-fpm \
    && chmod +x /usr/local/sbin/nginx-php-fpm \
    && rm -rf ./* && dnf clean all

COPY wordpress-6.4.3.tar.gz /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/
RUN tar -xvzf wordpress-6.4.3.tar.gz --strip-components=1 \
    && rm -rf xmlrpc.php wordpress-6.4.3.tar.gz \
    && sed -i 's/post_max_size = 8M/post_max_size = 500M/g' /etc/php.ini \
    && sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 500M/g' /etc/php.ini \
    && sed -i 's/;clear_env/clear_env/' /etc/php-fpm.d/www.conf \
    && sed -i 's/user = apache/user = nginx/' /etc/php-fpm.d/www.conf \
    && sed -i 's/group = apache/group = nginx/' /etc/php-fpm.d/www.conf \
    && chown -R 0:0 /usr/share/nginx/html && chmod g+w /usr/share/nginx/html \
    && chmod -R g+w /usr/share/nginx/html/wp-content && chmod g+w /run && chmod g+w /run/php-fpm \
    && chmod g+w /var/log/nginx && chmod g+w /var/log/php-fpm \
    && usermod -a -G 0 nginx
COPY wp-config.php /usr/share/nginx/html/
RUN chown 0:0 /usr/share/nginx/html/wp-config.php && chmod g+w /usr/share/nginx/html/wp-config.php


EXPOSE 8080
CMD ["nginx-php-fpm"]