FROM registry.access.redhat.com/ubi8/ubi

LABEL summary="Wordpress" \
      description="Wordpress container" \
      io.k8s.description="Wordpress Container" \
      io.k8s.display-name="Wordpress" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="wordpress" \
      name="pflaeging/wordpress" \
      version="1.0" \
      maintainer="Peter Pfläging <peter@pflaeging.net>"

# Install apache and http
RUN dnf --disableplugin=subscription-manager -y module enable php:7.4 \
  && dnf --disableplugin=subscription-manager -y install httpd php procps-ng mariadb-connector-c php-mysqlnd iputils\
  && dnf --disableplugin=subscription-manager clean all

# make passwd group writeable and set permissions
RUN sed -i -e 's/Listen 80/Listen 8080/' -e 's/User apache/User runner/' -e 's/Group apache/Group root/' /etc/httpd/conf/httpd.conf \
  && sed -i 's/listen.acl_users = apache,nginx/;listen.acl_users = runner/' /etc/php-fpm.d/www.conf \
  && chmod -R g=u /etc/passwd /etc \
  && mkdir /run/php-fpm /opt/sbin \
  && chgrp -R 0 /var/log/httpd /var/run/httpd /run/php-fpm /opt/sbin \
  && chmod -R g=u /var/log/httpd /var/run/httpd /run/php-fpm

ADD wordpress.tar.gz /opt

WORKDIR /opt/wordpress

RUN mv /opt/wordpress/wp-content /opt/wordpress/wp-content.install ; mkdir /opt/wordpress/wp-content \
  && chgrp root /opt/wordpress/wp-content; chmod g=rwx /opt/wordpress/wp-content \
  && rm -rf /var/www/html ; ln -s /opt/wordpress /var/www/html

ADD docker-entrypoint.sh /opt/sbin/
ADD wp-config.php.template
RUN chmod 755 /opt/sbin/docker-entrypoint.sh

EXPOSE 8080
VOLUME /opt/wordpress/wp-content/

USER 17711:0

ENTRYPOINT [ "/opt/sbin/docker-entrypoint.sh" ]

CMD php-fpm & httpd -D FOREGROUND