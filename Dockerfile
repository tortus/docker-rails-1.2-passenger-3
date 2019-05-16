FROM tortus/rails-1.2:latest

ENV APP=/app
ENV APP_USER=app
ENV APP_GROUP=www-data

# RUNLEVEL=1 prevents apache from starting immediately
RUN apt-get -o Acquire::Check-Valid-Until=false update && \
  RUNLEVEL=1 apt-get install -y --no-install-recommends \
    apache2 \
    apache2-dev \
    build-essential \
    dnsutils \
    libapr1 \
    libapr1-dev \
    libaprutil1 \
    libaprutil1-dev \
    libcurl3 \
    libcurl4-openssl-dev \
    libssl-dev \
    python3 \
    zlib1g \
    zlib1g-dev && \
  gem install rake -v 0.8.7 --no-ri --no-rdoc  && \
  gem install rack -v 1.1.6 --no-ri --no-rdoc && \
  gem install passenger -v 3.0.21 --no-ri --no-rdoc && \
  passenger-install-apache2-module --auto && \
  a2enmod headers && \
  a2enmod env && \
  a2disconf serve-cgi-bin && \
  apt-get purge -y --no-install-recommends --auto-remove \
    apache2-dev \
    build-essential \
    libapr1-dev \
    libaprutil1-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    zlib1g-dev && \
  mkdir -p $APP && \
  useradd -rms /bin/bash -u 999 -g $APP_GROUP $APP_USER && \
  chown $APP_USER:$APP_GROUP $APP && \
  sed -ri ' \
s!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g; \
s!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g; \
' /etc/apache2/apache2.conf && \
  echo "\nexport APP_USER=$APP_USER\nexport APP_GROUP=$APP_GROUP" | tee -a /etc/apache2/envvars && \
  a2dissite 000-default && \
  mkdir /etc/on-server-start && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY build /build
COPY bin/* /usr/local/bin/
COPY on-server-start/*.sh /etc/on-server-start/
COPY mpm_event.conf /etc/apache/conf-available/mpm_event.conf
COPY mpm_prefork.conf /etc/apache/conf-available/mpm_prefork.conf
COPY passenger.conf /etc/apache2/conf-enabled/passenger.conf
COPY security.conf /etc/apache2/conf-available/security.conf

ENV MIGRATE="false"

WORKDIR /app

CMD ["/usr/local/bin/httpd-foreground"]
EXPOSE 80
LABEL server="apache2" ruby="1.8.7-p375" passenger="3.0.21" rails="1.2.6"
