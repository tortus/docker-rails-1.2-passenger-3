**NOT FOR USE IN PRODUCTION**

Base image for running Rails 1.2 applications in their original production mode
under Apache 2 / Passenger 3.0.21.

## Running an App

1. Put the source under /var/www/app.
2. Change the ownership to www-data:www-data.

## Notes

* Rake 0.8.7 is needed for passenger to install (Rake 0.7.3 from the base image
  is insufficient).
