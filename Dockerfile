FROM ubuntu:16.04

RUN apt-get -y update

# install sshd
RUN apt-get install -y vim openssh-server

# enable login with root over ssh
RUN mkdir /var/run/sshd 
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# create volume
RUN mkdir -p /root/build
VOLUME /root/build

# http://packages.ubuntu.com/de/trusty/build-essential
RUN apt-get -y install build-essential

# http://packages.ubuntu.com/de/trusty/valgrind
RUN apt-get -y install valgrind

# cpp_build dependencies
RUN apt-get -y install g++ git libboost-atomic-dev libboost-thread-dev libboost-system-dev libboost-date-time-dev libboost-regex-dev libboost-filesystem-dev libboost-random-dev libboost-chrono-dev libboost-serialization-dev libwebsocketpp-dev openssl libssl-dev ninja-build

RUN apt-get -y install libcpprest-dev

# launch
CMD /usr/sbin/sshd -D
EXPOSE 22
