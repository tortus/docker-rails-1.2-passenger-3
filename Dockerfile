FROM tortus/ruby-1.8-rails-1.2:latest
LABEL server="apache2" ruby="1.8.7-p375" passenger="3.0.21" rails="1.2.6"

ENV APP=/var/www/rails
ENV APPUSER=rails
ENV RAILS_ENV=development

# Addl. runtime dependencies (RUNLEVEL=1 prevents apache from starting immediately)
#
# TODO: Delete build dependencies after passenger and all gems installed.
RUN apt-get -o Acquire::Check-Valid-Until=false update && \
  RUNLEVEL=1 apt-get install -y --no-install-recommends \
    apache2 \
    apache2-dev \
    build-essential \
    libapr1 \
    libapr1-dev \
    libapr-util1 \
    libaprutil1-dev \
    libcurl3 \
    libcurl4-openssl-dev \
    openssl \
    libssl1.0.0 \
    libssl-dev \
    zlib1g \
    zlib1g-dev && \
  gem install rake -v 0.8.7 && \
  gem install rack -v 1.1.6 && \
  gem install passenger -v 3.0.21 && \
  passenger-install-apache2-module --auto && \
  a2enmod headers && \
  a2enmod env && \
  apt-get purge -y --no-install-recommends --auto-remove \
    apache2-dev \
    build-essential \
    libapr1-dev \
    libaprutil1-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    zlib1g-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir -p $APP && \
  useradd -rms /bin/bash -u 999 -g www-data $APPUSER && \
  chown rails:www-data $APP

COPY passenger.conf /etc/apache2/conf-enabled/
COPY httpd-foreground /usr/local/bin/
COPY z-apache.conf /etc/apache2/conf-enabled/
COPY rails.conf /etc/apache2/sites-available/000-default.conf

VOLUME /var/log/apache2

WORKDIR $APP

CMD ["/usr/local/bin/httpd-foreground"]
EXPOSE 80
