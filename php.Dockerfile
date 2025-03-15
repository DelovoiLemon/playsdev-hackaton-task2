FROM php:7.4-fpm
WORKDIR /var/www/html
COPY ./host/ /usr/share/nginx/html/
EXPOSE 9000
CMD ["php-fpm"]