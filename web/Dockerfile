FROM alpine

MAINTAINER Sergey Ustyuzhanin SibData Company <dir@sibdata.ru>

ENV TZ Asia/Novosibirsk

COPY scripts/ /

RUN /install.sh

EXPOSE 80

ENTRYPOINT ["/start.sh"]
