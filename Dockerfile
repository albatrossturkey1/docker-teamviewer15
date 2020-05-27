FROM ubuntu:20.04

MAINTAINER tukiyo3 <tukiyo3@gmail.com>

# install Teamviewer 15
RUN apt update \
    && apt install --no-install-recommends -y sudo busybox \
    && busybox --install \
    && wget "https://dl.teamviewer.com/download/linux/version_15x/teamviewer_15.5.3_amd64.deb" \
    && dpkg -i teamviewer_15.5.3_amd64.deb || apt install -y -f --no-install-recommends \
    && rm -f teamviewer_15.5.3_amd64.deb \
    && apt clean \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# teamviewer daemon を動かすにはsudoできる必要がある
RUN echo "docker ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/nopasswd \
 && echo "Set disable_coredump false" >> /etc/sudo.conf

# Teamviewer を動かすには一般ユーザーが必要
RUN adduser --disabled-password --gecos sudo docker

ENV DISPLAY :0.0
ENV USER docker
USER docker
VOLUME ["/tmp/.X11-unix"]
CMD sudo /usr/bin/teamviewer --daemon start && /usr/bin/teamviewer
