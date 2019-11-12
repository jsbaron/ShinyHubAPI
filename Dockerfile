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
RUN apt-get -y install valgrind \
    libmodbus5 liblog4cxx10v5 \
    libboost-regex1.58.0 libboost-system1.58.0 \
    libboost-program-options1.58.0 libboost-thread1.58.0 \
    libboost-filesystem1.58.0 libpthread-workqueue0 \
    libssl1.0.0 libcpprest-dev autotools-dev

# launch
CMD /usr/sbin/sshd -D
EXPOSE 22
