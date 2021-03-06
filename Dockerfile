FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  jq mosquitto-clients python3 python3-pip python3-rpi.gpio curl \
  && pip3 install --no-cache mh_z19 \
  && rm -rf /var/lib/apt/lists/*

COPY ./init /init
COPY ./loop /loop

RUN chmod +x /init && chmod +x /loop

ENTRYPOINT ["/init"]
CMD ["/loop"]
