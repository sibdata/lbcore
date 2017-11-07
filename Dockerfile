FROM centos:7

MAINTAINER Sergey Ustyuzhanin SibData Company <dir@sibdata.ru>

##COPY lbcore-2.0.23.0-203.gitf6ab08e1.el7.x86_64.rpm /

RUN localedef -i ru_RU -f UTF-8 ru_RU.UTF-8

ENV LC_ALL ru_RU.UTF-8
ENV LANG ru_RU.UTF-8

RUN yum update -y
RUN yum install epel-release -y -q
RUN yum install yum-utils -y -q
RUN yum install expect -y -q
RUN mkdir -p /root/billing
yum-config-manager --add-repo https://pkgs.lanbilling.ru/rpm/lb20/7/main/736962646174615f32/ef40a99ce87c941658eb5fc30461b49f33898ca0/lanbilling-2.0-release.repo
##RUN yum localinstall lbcore* -y -q
RUN yum install lbcore* -y -q
RUN rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
RUN yum install mysql -y
RUN sed -i "s|logfile = ./lbcore.log|logfile = /root/billing/logs/lbcore.log|" /etc/billing.conf
RUN sed -i "s|listen = 127.0.0.1:1502|listen = 0.0.0.0:1502|" /etc/billing.conf
RUN echo "0" > /root/billing/installed.txt
COPY scripts/start.sh /
VOLUME "/root/billing"
ENTRYPOINT ["/start.sh"]
CMD ["/usr/local/billing/LBcore","-n","-c","/root/billing/conf/billing.conf","-L","/root/billing/logs/lbcore.log"]
