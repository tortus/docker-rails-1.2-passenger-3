**NOT FOR USE IN PRODUCTION**

Base image for running Rails 1.2 applications in their original production mode under Apache 2 / Passenger 3.0.21. Your app will run under the "rails" user, in the www-data group.

**RailsEnv** Is set to "development" by default, to make debugging far easier. This must be changed via apache config.

## Running an App

1. Put the source under /var/www/rails.
2. Change the ownership to rails:www-data.
3. If you need to change the vhost configuration for it, copy your .conf file to /etc/apache2/sites-available/000-default.conf

## Notes

* Rake 0.8.7 is needed for passenger to install (Rake 0.7.3 from the base image
  is insufficient).
* Apache does not log to stdout, or the rails log. You must link a volume to /var/log/apache2 to get at apache logs.
