**NOT FOR USE IN PRODUCTION**

Base image for running Rails 1.2 applications in their original production mode under Apache 2 / Passenger 3.0.21. Your app will run under the "rails" user, in the www-data group.

**RailsEnv** Is set to "development" by default, to make debugging far easier. This must be changed via apache config.

## Running an App

1. Put the source under /var/www/rails.
2. Change the ownership to rails:www-data.
3. If you need to change the vhost configuration for it, copy your .conf file to /etc/apache2/sites-available/000-default.conf

Basic vhost template:

```apache
<VirtualHost *:80>
  DocumentRoot /app/public

  RailsEnv ${RAILS_ENV}
</VirtualHost>
```

## Custom application environment variables

This image will append the contents of the environment variable `$APACHE\_ENV_VARS` to /etc/apache2/envvars on startup. Use this variable to make custom environment variables available to your app.

Example:

docker-compose.yml:
```yaml
environment:
  - APACHE_ENV_VARS='SMTP_HOST=smtp'
```

/etc/apache2/sites-available/000-default.conf:
```apache
<VirtualHost *:80>
  DocumentRoot /app/public

  RailsEnv ${RAILS_ENV}
  SetEnv SMTP_HOST ${SMTP_HOST}
</VirtualHost>
```

Passenger applications running within Apache do not have access to Docker environment variables, just the ones Apache sets using the `SetEnv` directive, so some annoyance is needed to get them into your app.

## Notes

* Rake 0.8.7 is needed for passenger to install (Rake 0.7.3 from the base image
  is insufficient).
* Apache does not log to stdout, or the rails log. You must link a volume to /var/log/apache2 to get at apache logs.
