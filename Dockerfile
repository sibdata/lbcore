FROM centos:7

MAINTAINER Sergey Ustyuzhanin SibData Company <dir@sibdata.ru>

RUN yum update -y \

&& yum install epel-release -yq \

&& yum install htop -yq \

&& yum install yum-utils -yq \

&& yum install mc -yq \

&& mkdir -p /root/billing \

&& yum-config-manager --add-repo https://pkgs.lanbilling.ru/rpm/lb20/7/main/736962646174615f32/ef40a99ce87c941658eb5fc30461b49f33898ca0/lanbilling-2.0-release.repo \

&& yum install lbcore-2.0.23* -yq \

&& cp -f /etc/billing.conf /root/billing

## VOLUME "/root/billing"

CMD ["/usr/local/billing/LBcore","-n","-c","/root/billing/billing.conf","-L","/root/billing/lbcore.log"]
