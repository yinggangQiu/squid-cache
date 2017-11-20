#
# 
# DOCKER-VERSION    1.7.1
#
# Dockerizing CentOS7: Dockerfile for building CentOS images
#
FROM       centos
MAINTAINER qiuyinggang <qiuyinggang@3mang.com>

ENV TZ "Asia/Shanghai"
ENV TERM xterm
ENV DATA_DIR /usr/local/squid/var

ADD aliyun-mirror.repo /etc/yum.repos.d/CentOS-Base.repo
ADD aliyun-epel.repo /etc/yum.repos.d/epel.repo
ADD squid.conf /etc/squid/squid.conf
ADD scripts /scripts
RUN chmod +x /scripts/init.sh

RUN yum install -y curl wget tar bzip2 unzip vim-enhanced passwd sudo yum-utils hostname net-tools rsync man && \
    yum install -y gcc gcc-c++ git make automake cmake patch logrotate python-devel libpng-devel libjpeg-devel && \
    yum install -y --enablerepo=epel pwgen python-pip && \
    yum clean all
RUN yum install -y squid
RUN pip install supervisor
ADD supervisord.conf /etc/supervisord.conf

RUN mkdir ${DATA_DIR}/cache  -p &&  mkdir ${DATA_DIR}/logs -p &&chmod 777 -R ${DATA_DIR}
RUN mkdir -p /etc/supervisor.conf.d && \
    mkdir -p /var/log/supervisor
VOLUME ["/usr/local/squid/var"]

EXPOSE  3128 

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
