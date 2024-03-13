FROM balenalib/armv7hf-debian:bullseye

LABEL description="bullseye v1.0 deploy with --privileged"

RUN [ "cross-build-start" ]

ENV UDEV=1

# Install packages
RUN apt-get -qq update 
RUN apt-get -qq install --no-install-recommends -y \
    apt-utils \
    wget \
    git 

RUN wget -q https://flightaware.com/adsb/piaware/files/packages/pool/piaware/f/flightaware-apt-repository/flightaware-apt-repository_1.2_all.deb
RUN dpkg -i flightaware-apt-repository_1.2_all.deb

RUN apt-get -qq update
RUN apt-get -qq install --no-install-recommends -y \
      piaware \
      dump1090-fa 

# openLayers
RUN git clone  https://github.com/alkissack/Dump1090-OpenLayers-html.git

# remove install tools
RUN apt-get -qq remove -y --purge \
	apt-utils \
	wget \
	git \
    && apt-get -qq autoremove -y
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /run/dump1090-fa 
RUN mkdir /run/piaware 
#RUN cp /etc/lighttpd/conf-available/89-dump1090-fa.conf /etc/lighttpd/conf-enabled

COPY 90-Dump1090-OpenLayers.conf /etc/lighttpd/conf-enabled
COPY config.js Dump1090-OpenLayers-html/public_html
COPY index.html Dump1090-OpenLayers-html/public_html
COPY script.js Dump1090-OpenLayers-html/public_html

# startup script
COPY startPiaware.sh /root
RUN chmod +x /root/startPiaware.sh

CMD  /root/startPiaware.sh

# PiAware Skyview web page:
EXPOSE 8080
# OpenLayers web page:
EXPOSE 8181

# for connections to other viewing tools, e.g. Virtual Radar:
# non-MLAT data in Beast format:
EXPOSE 30005
# MLAT data in Beast format:
EXPOSE 30105

RUN [ "cross-build-end" ]

