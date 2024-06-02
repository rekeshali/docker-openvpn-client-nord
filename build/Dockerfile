FROM alpine:3.17

RUN apk add --no-cache \
    bash \
    bind-tools \
    iptables \
    ip6tables \
    openvpn

WORKDIR /etc/openvpn
RUN wget https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip
RUN unzip ovpn.zip
RUN rm ovpn.zip

WORKDIR /
COPY . /usr/local/bin

ENV KILL_SWITCH=on
ENV ALLOWED_SUBNETS=192.168.10.0/24
ENV OPENVPN_TECHNOLOGY=udp

ENTRYPOINT [ "entry.sh" ]
