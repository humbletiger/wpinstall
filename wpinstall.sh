#!/bin/bash -e
clear
echo "============================================"
echo "WordPress Install Script"
echo "============================================"

echo "Project Name:"
read -e pname

echo "Database Name: "
read -e dbname

echo "Database User: "
read -e dbuser

echo "Database Password: "
read -s dbpass

echo "Run install? (y/n)"
read -e run

if [ "$run" == n ] ; then
exit
else

echo "Downloading latest WordPress"
curl -O https://wordpress.org/latest.tar.gz

echo "Unzipping WordPress"
tar -zxvf latest.tar.gz

echo "Renaming to $pname"
mv  wordpress $pname 
cd $pname

echo "Creating MYSQL stuff. Root password required."

MYSQL=`which mysql`

Q1="CREATE DATABASE IF NOT EXISTS $dbname;"
Q2="GRANT USAGE ON *.* TO $dbuser@localhost IDENTIFIED BY '$dbpass';"
Q3="GRANT ALL PRIVILEGES ON $dbname.* TO $dbuser@localhost;"
Q4="FLUSH PRIVILEGES;"

SQL="${Q1}${Q2}${Q3}${Q4}"

$MYSQL -uroot -p -e "$SQL"

echo "Running wp-cli core config and db create"
wp core config --dbname=$dbname --dbuser=$dbuser --dbpass=$dbpass
#wp db create

echo "Cleaning Up"
cd ..
rm latest.tar.gz


echo "========================="
echo "Installation is complete."
echo "========================="
fi
