FROM centos:7

MAINTAINER Sergey Ustyuzhanin SibData Company <dir@sibdata.ru>

RUN yum update -y \

&& yum install epel-release -yq \

&& yum install yum-utils -yq \

&& yum install mc -yq \

&& mkdir -p /root/billing \

&& yum-config-manager --add-repo https://pkgs.lanbilling.ru/rpm/lb20/7/main/736962646174615f32/ef40a99ce87c941658eb5fc30461b49f33898ca0/lanbilling-2.0-release.repo \

&& yum-config-manager --add-repo https://pkgs.lanbilling.ru/rpm/lb20/6/update/736962646174615f32/ef40a99ce87c941658eb5fc30461b49f33898ca0/lanbilling-2.0-hotfix.repo \

&& yum install lbcore* -yq \

&& echo "0" > /root/billing/installed.txt

ADD scripts/start.sh /

VOLUME "/root/billing"

ENTRYPOINT ["/start.sh"]

CMD ["/usr/local/billing/LBcore","-n","-c","/root/billing/conf/billing.conf","-L","/root/billing/logs/lbcore.log"]
