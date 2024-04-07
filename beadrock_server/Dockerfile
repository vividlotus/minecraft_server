FROM ubuntu:24.04

ENV TZ Asia/Tokyo

RUN apt update \
    && apt install -y --no-install-recommends \
        tzdata \
        curl \
        openjdk-23-jre

WORKDIR /beadrock_server

CMD ["bash", "entrypoint.sh"]
