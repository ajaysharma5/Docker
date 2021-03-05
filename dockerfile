FROM centos:centos7
MAINTAINER ajay

RUN yum install -y wget
RUN yum install -y epel-release
RUN yum install -y nginx

COPY index.html /data/www/index.html
COPY nginx.conf /etc/nginx/nginx.conf
VOLUME [ "/data/www" ]
EXPOSE 80
CMD [“echo”,”Image created”]
