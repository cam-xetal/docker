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

#git
RUN yum -y install curl wget
RUN yum -y install epel-release
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN rpm -ivh remi-release-7.rpm

#supervisor
RUN yum -y install supervisor
RUN sed -ri 's/^nodaemon=false/nodaemon=true/' /etc/supervisord.conf

#mariadb
RUN yum -y install mariadb-devel mariadb mariadb-libs mariadb-server hostname
RUN mysql_install_db
RUN chown -R mysql:mysql /var/lib/mysql
ADD mysqld.ini /etc/supervisord.d/mysqld.ini

#Redis
RUN yum -y install libunwind libunwind-devel gperftools-libs redis
RUN yum -y install icu4c libicu-devel libxml2 libxml2-devel libxslt libxslt-devel cmake
ADD redis.ini /etc/supervisord.d/redis.ini

##ruby
RUN yum -y install ruby
RUN yum -y groupinstall "Development Tools"
RUN yum -y install mysql-devel ruby-devel rubygems

#user add
RUN useradd -c 'GitLab' -s /bin/bash -m git

#rails
RUN sudo -u git gem install rails mysql2

##gitlab-shell
RUN sudo -u git git config --global user.name "GitLab"
RUN sudo -u git git config --global user.email "gitlab@localhost"
RUN sudo -u git git clone https://github.com/gitlabhq/gitlab-shell.git /home/git/gitlab-shell
RUN cd /home/git/gitlab-shell && sudo -u git git checkout -b 1.9.8 v1.9.8
RUN cd /home/git/gitlab-shell && sudo -u git cp config.yml.example config.yml
RUN cd /home/git/gitlab-shell && sudo -u git ./bin/install

#gitlab
RUN sudo -u git git clone https://github.com/gitlabhq/gitlabhq.git /home/git/gitlab
RUN cd /home/git/gitlab && sudo -u git git checkout -b 7.3.0 v7.3.0
RUN cd /home/git/gitlab && sudo -u git cp config/gitlab.yml.example config/gitlab.yml

#bundl
RUN sudo -u git /home/git/bin/bundle install --deployment --without development test postgres

#create databese
RUN sudo -u git /home/git/bin/bundle exec rake db:create RAILS_ENV=production
RUN sudo -u git /home/git/bin/bundle exec rake gitlab:setup RAILS_ENV=production

#port expose
#EXPOSE 3306
#start supervisord
CMD ["/usr/bin/supervisord"]
