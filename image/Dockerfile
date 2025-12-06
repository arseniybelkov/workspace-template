FROM ubuntu:24.04

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# SSH
RUN apt update && apt upgrade -y
RUN apt install openssh-server -y

ENV CXX="/usr/bin/clang++-19"
ENV CC="/usr/bin/clang-19"

EXPOSE 22
RUN echo "StrictHostKeyChecking=no" >> /etc/ssh/ssh_config
RUN mkdir /var/run/sshd
CMD ["/usr/sbin/sshd", "-D"]
