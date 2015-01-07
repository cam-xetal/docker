FROM centos

MAINTAINER Yoshihiro Maeda

RUN yum -y install yum
RUN yum -y update

#root password : root
RUN echo 'root:root' | chpasswd

#sudo
RUN yum -y install sudo 
RUN sed -ri 's/^Defaults    requiretty/#Defaults    requiretty/' /etc/sudoers

#epel
RUN yum -y install curl wget
RUN yum -y install epel-release
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN rpm -ivh remi-release-7.rpm

#user add
RUN useradd -c 'GitLab' -s /bin/bash -m git

#supervisor
RUN yum -y install supervisor
RUN sed -ri 's/^nodaemon=false/nodaemon=true/' /etc/supervisord.conf

#mariadb
RUN yum -y install mariadb-devel mariadb mariadb-libs mariadb-server
#require mysql_install_db
RUN yum -y install hostname	
RUN mysql_install_db
RUN chown -R mysql:mysql /var/lib/mysql

#expose port
EXPOSE 3306

#run supervisord
CMD ["/usr/bin/supervisord"]
