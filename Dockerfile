FROM centos
RUN yum -y install yum
RUN yum -y update

#root password : root
RUN echo 'root:root' | chpasswd

#devlop 
#RUN yum -y install vim git 
