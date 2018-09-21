FROM python:2.7
EXPOSE 5000
LABEL maintainer "techunter.chaos@gmail.com"

ARG tag=master

WORKDIR /opt/octoprint

# In case of alpine
#RUN apk update && apk upgrade \
#    && apk add --no-cache bash git openssh gcc\
#               && pip install virtualenv \
#               && rm -rf /var/cache/apk/*

RUN apt-get update && apt-get install -y cmake build-essential python3-dev python3-sip-dev

#install ffmpeg
RUN cd /tmp \
  && wget -O ffmpeg.tar.xz https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-32bit-static.tar.xz \
        && mkdir -p /opt/ffmpeg \
        && tar xvf ffmpeg.tar.xz -C /opt/ffmpeg --strip-components=1 \
  && rm -Rf /tmp/*

#cloning libs
RUN cd /tmp \
        && git clone https://github.com/protocolbuffers/protobuf.git \
        && git clone https://github.com/Ultimaker/libArcus.git \
        && git clone https://github.com/Ultimaker/CuraEngine.git

#install protobuff
RUN cd /tmp/protobuf \
        && chmod +x autogen.sh \
        && ./autogen.sh \
        && ./configure \
        && make \
        && make install \
        && ldconfig
#install Arcus
RUN cd /tmp/libArcus \
        && mkdir -p build && cd build \
        && cmake .. && make \
        && make install \
        && ldconfig

#install Cura
RUN cd /tmp/CuraEngine \
        && mkdir -p build \
        && cd build \
        && cmake .. \
        && make \
        && mkdir -p /opt/cura \
        && mv -f ./* /opt/cura/

#clean up
RUN rm -Rf /tmp/*

#Create an octoprint user
RUN useradd -ms /bin/bash octoprint \
        && adduser octoprint dialout \
        && chown -R octoprint:octoprint /opt/octoprint \
        && chown -R octoprint:octoprint /opt/cura
USER octoprint

#This fixes issues with the volume command setting wrong permissions
RUN mkdir /home/octoprint/.octoprint

#Install Octoprint
RUN git clone --branch $tag https://github.com/foosel/OctoPrint.git /opt/octoprint \
  && virtualenv venv \
	&& ./venv/bin/python setup.py install

VOLUME /home/octoprint/.octoprint


CMD ["/opt/octoprint/venv/bin/octoprint", "serve"]
