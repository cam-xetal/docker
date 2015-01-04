FROM centos
RUN yum -y install yum
RUN yum -y update
RUN yum -y swap fakesystemd systemd

#root password : root
RUN echo 'root:root' | chpasswd

#devlop 
RUN yum -y install zsh vim git
RUN git clone https://github.com/cam-xetal/dot_files.git ~/dot_files
RUN ~/dot_files/setting.sh
RUN yum -y install sudo 

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
#RUN sed -i -e "s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/my.cnf

#Redis
RUN yum -y install libunwind libunwind-devel gperftools-libs redis
RUN yum -y install icu4c libicu-devel libxml2 libxml2-devel libxslt libxslt-devel cmake
ADD redis.ini /etc/supervisord.d/redis.ini

##ruby
RUN yum -y install ruby
RUN yum -y groupinstall "Development Tools"
RUN yum -y install mysql-devel ruby-devel rubygems

#rails
RUN gem install rails mysql2

#user add
RUN useradd -c 'GitLab' -s /bin/bash -m git
RUN mkdir /home/git/.ssh/
RUN touch /home/git/.ssh/authorized_keys
RUN chmod 600 /home/git/.ssh/authorized_keys
RUN chmod 700 /home/git/.ssh
RUN chown -R git /home/git

##gitlab-shell
RUN sudo -u git git config --global user.name "GitLab"
RUN sudo -u git git config --global user.email "gitlab@localhost"
RUN sudo -u git git clone https://github.com/gitlabhq/gitlab-shell.git /home/git/gitlab-shell
RUN cd /home/git/gitlab-shell && sudo -u git git checkout -b 1.9.8 v1.9.8
RUN cd /home/git/gitlab-shell && sudo -u git cp config.yml.example config.yml
RUN cd /home/git/gitlab-shell && sudo -u ./bin/install

#gitlab
RUN sudo -u git git clone https://github.com/gitlabhq/gitlabhq.git /home/git/gitlab
RUN cd /home/git/gitlab && sudo -u git git checkout -b 7.3.0 v7.3.0
RUN cd /home/git/gitlab && sudo -u git cp config/gitlab.yml.example config/gitlab.yml

#bundl
RUN bundle install --deployment --without development test postgres

#create databese
RUN bundle exec rake db:create RAILS_ENV=production
RUN bundle exec rake gitlab:setup RAILS_ENV=production

#port expose
#EXPOSE 3306
#start supervisord
CMD ["/usr/bin/supervisord"]
#RUN mysql_secure_installation
