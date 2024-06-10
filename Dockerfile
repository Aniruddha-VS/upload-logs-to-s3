FROM amazonlinux

RUN yum update -y && \
    yum install -y cronie && \
    yum install -y unzip && \
    yum clean all && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
    unzip -u awscliv2.zip && \
    ./aws/install && \
    touch /var/log/cron.log

COPY sample.log /var/log/sample.log
COPY upload_to_s3.sh /usr/local/bin/upload_to_s3.sh
COPY crontab /etc/crontab
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod 0744  /usr/local/bin/upload_to_s3.sh && \
    chmod 0644 /etc/crontab && \
    chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

