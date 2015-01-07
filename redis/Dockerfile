FROM centos
RUN yum -y install yum
RUN yum -y update

#root password : root
RUN echo 'root:root' | chpasswd

#devlop 
RUN yum -y install zsh vim git
RUN git clone https://github.com/cam-xetal/dot_files.git ~/dot_files
RUN ~/dot_files/setting.sh

#sudo
RUN yum -y install sudo 
RUN sed -ri 's/^Defaults    requiretty/#Defaults    requiretty/' /etc/sudoers

#epel
RUN yum -y install curl wget
RUN yum -y install epel-release
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN rpm -ivh remi-release-7.rpm

#supervisor
RUN yum -y install supervisor
RUN sed -ri 's/^nodaemon=false/nodaemon=true/' /etc/supervisord.conf

#Redis
RUN yum -y install libunwind libunwind-devel gperftools-libs redis
RUN yum -y install icu4c libicu-devel libxml2 libxml2-devel libxslt libxslt-devel cmake
ADD redis.ini /etc/supervisord.d/redis.ini

#port expose
#EXPOSE 3306
#start supervisord
CMD ["/usr/bin/suprvisord"]
