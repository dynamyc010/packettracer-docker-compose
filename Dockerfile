# syntax=docker/dockerfile:1
FROM ubuntu:20.04
ENV TZ=Europe/Budapest
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ >> /etc/timezone
RUN apt-get update
# These are (a bit more than) the dependencies for 8.1.1, may change.
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y xauth wget tar vim less sudo dialog xdg-utils gtk-update-icon-cache libgl1-mesa-glx libpulse0 libnss3 libxss1 libasound2 libxslt1.1 libxkbcommon-x11-0 libxcb-xinerama0-dev libfreetype6 wget xauth libqt5webkit5 libqt5xml5 libqt5multimedia5 libqt5script5 libqt5scripttools5 sudo libnss3 libxss1 libasound2 vim less
RUN useradd -ms /bin/bash cisco
WORKDIR /home/cisco/
# We require a local Cisco installer
COPY CiscoPacketTracer_811_Ubuntu_64bit.deb CiscoPacketTracer_811_Ubuntu_64bit.deb
RUN mkdir -p pt_package/DEBIAN
RUN dpkg-deb -x ./CiscoPacketTracer_811_Ubuntu_64bit.deb ./pt_package/ 
RUN dpkg-deb -e ./CiscoPacketTracer_811_Ubuntu_64bit.deb ./pt_package/DEBIAN/ 
# I hate these shenanigans it requires.
RUN rm -f ./pt_package/DEBIAN/preinst
RUN dpkg-deb -Z xz -b ./pt_package/ .
RUN dpkg -i ./packettracer_8.1.1_amd64.deb
RUN chown 1000:1000 -Rv /opt/pt

USER cisco
ENV HOME /home/cisco
WORKDIR /opt/pt/bin
CMD /usr/local/bin/packettracer