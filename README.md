y first repository and my initial image: an easy setup featuring AlmaLinux 9, nginx, PHP 8.1, and WordPress 6.4.3. This is a WordPress installation ready for configuration, and I will continue refining this image.

The setup utilizes environment variables for the database connection:

DB_USER: Database username DB_PASSWORD: Database password DB_DATABASE: Database name DB_HOST: IP or hostname of the database DB_PREFIX: prefix for the table names, default wp_

It works by exposing port 8080, thinking about containers without privileges.
