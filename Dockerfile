FROM centos
RUN yum -y install yum
RUN yum -y update

#root password : root
RUN echo 'root:root' | chpasswd

#sshd
RUN yum -y install openssh-server
RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
#CMD ["/usr/sbin/sshd", "-D"]
#RUN /etc/rc.d/init.d/sshd start

EXPOSE 22
#CMD /sbin/init
#devlop 
#RUN yum -y install vim git 
