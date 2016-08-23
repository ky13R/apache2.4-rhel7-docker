FROM rhel7

RUN yum install httpd mod_rewrite php* mod_ssl -y && yum update -y && yum clean all

COPY virtual.conf $HOME
COPY httpd.key $HOME
COPY httpd.pem $HOME

RUN mv virtual.conf /etc/httpd/conf.d/virtual.conf && mv httpd.key /etc/httpd/conf.d/httpd.key && mv httpd.pem /etc/httpd/conf.d/httpd.pem

#RUN mkdir -p /customDir
#RUN chown 497:494 /customDir

RUN chown -R apache:apache /var/log/httpd && chown -R apache:apache /etc/httpd && chmod -R 777 /var/run/httpd && chmod -R 777 /etc

RUN sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf && sed -i 's/Listen 443/Listen 8443/g' /etc/httpd/conf.d/ssl.conf && sed -i 's/VirtualHost _default_:443/VirtualHost _default_:8443/g' /etc/httpd/conf.d/ssl.conf

EXPOSE 8443

USER apache

CMD /usr/sbin/httpd -D FOREGROUND
