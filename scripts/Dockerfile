FROM ruby:3.3-slim

ENV TZ Asia/Tokyo

RUN apt update \
    && apt install -y --no-install-recommends \
        tzdata \
        cron \
        curl \
        wget \
        unzip \
        jq \
    && gem install rubyzip activesupport

WORKDIR /app

RUN printenv | awk '{print "export " $1}' > /root/env.sh

COPY ./scripts/crontab /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab
RUN /usr/bin/crontab /etc/cron.d/crontab

CMD ["cron", "-f"]
