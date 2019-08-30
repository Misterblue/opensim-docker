#! /bin/bash

mysql -u root --password=${MYSQL_ROOT_PASSWORD} <<<EOFFFF
CREATE DATABASE opensim;
USE opensim;
CREATE USER 'opensim'@'%' IDENTIFIED BY 'opensimit';
GRANT ALL ON opensim.* to 'opensim'@'%';
quit
EOFFFF

