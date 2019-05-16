**NOT FOR USE IN PRODUCTION**

Base image for running Rails 1.2 applications in their original production mode under Apache 2 / Passenger 3.0.21. The app will run under the "app" user, in the www-data group. As minimal as possible, does not include a lot of the things a good working image probably needs such as database headers and pre-server-start scripts.

**RailsEnv** Is set to "development" by default, to make debugging easier.

Includes:

* Ruby 1.8.7
* Rails 1.2
* Apache 2
* Rake 0.8.7
* Rack 1.1.6
* Passenger 3

Does _NOT_ include:

* PHP

## Running an App

1. Put the source under /app.
2. Change the ownership to app:www-data.
3. Copy your Apache vhost .conf file to /etc/apache2/sites-enabled/mysite.conf

Basic vhost template:

```apache
<VirtualHost *:80>
  DocumentRoot /app/public

  RailsEnv ${RAILS_ENV}
</VirtualHost>
```

## Pre-Start Scripts

Any executable files in /etc/on-server-start/ will be executed prior to Apache startup. This is useful for migrating the database.

## Apache Tuning

Custom configuration files are provided for mpm\_event and mpm\_prefork to keep the number of apache processes down and reduce memory usage for development.

## Custom application environment variables

Docker environment variables seem to get passed to the Rails app just fine, even though it is running within an Apache process. However, this image will append the contents of the environment variable `$APACHE\_ENV_VARS` to /etc/apache2/envvars on startup. Use this variable to make custom environment variables available to Apache.

Example:

docker-compose.yml:
```yaml
environment:
  - APACHE_ENV_VARS='SMTP_HOST=smtp'
```

/etc/apache2/sites-enabled/mysite.conf:
```apache
<VirtualHost *:80>
  DocumentRoot /app/public

  RailsEnv ${RAILS_ENV}
  SetEnv SMTP_HOST ${SMTP_HOST}
</VirtualHost>
```

## Notes

* Rake 0.8.7 is needed for passenger to install (Rake 0.7.3 from the base image
  is insufficient).
