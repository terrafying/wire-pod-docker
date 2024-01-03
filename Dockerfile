FROM ubuntu:latest

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
 && apt-get install -y sudo avahi-daemon git \
 && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN adduser --disabled-password --gecos '' wirepod
RUN adduser wirepod sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER wirepod

RUN sudo mkdir /wire-pod
RUN sudo chown -R wirepod:wirepod /wire-pod

RUN git clone https://github.com/kercre123/wire-pod/ --depth=1 /wire-pod

WORKDIR /wire-pod


# idk
RUN sudo sh -c 'yes 3 | ./setup.sh'

COPY <<EOF /wire-pod/chipper/source.sh
export DEBUG_LOGGING=true
EOF

RUN sed -i 's#/usr/local/go/bin/go#go#g' /wire-pod/chipper/start.sh
CMD sudo STT_SERVICE=whisper ./chipper/start.sh
