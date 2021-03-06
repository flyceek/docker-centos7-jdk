FROM php:7.4-rc-fpm-alpine3.10
MAINTAINER flyceek <flyceek@gmail.com>

ENV USER=paranora
ENV USERID=1090
ENV GROUP=paranora
ENV GROUPID=1090

RUN apk update upgrade \
    && cd /var/www/ \
    && apk add --no-cache bash curl git \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer \
    && addgroup -g ${GROUPID} ${GROUP} \
    && adduser -h /home/${USER} -u ${USERID} -G ${GROUP} -s /bin/bash -D ${USER} \
    && git clone --depth=1 --single-branch --branch=master https://github.com/peinhu/AetherUpload-Laravel.git \
    && chmod -R 777 /var/www/ \
    && cd AetherUpload-Laravel \
    && su paranora \
    && composer install --no-dev \
    && { \
		echo '#!/bin/sh'; \
		echo 'cd /var/www/AetherUpload-Laravel'; \
        echo 'echo 123321'; \
	} > /usr/local/bin/start \
    && chmod +x /usr/local/bin/start 

USER paranora
EXPOSE 8080
CMD ["start"] 
