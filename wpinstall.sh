#!/bin/bash -e
clear
echo "============================================"
echo "WordPress Install Script"
echo "============================================"

#note: check to see if wpcli is installed. If not, abort.
echo "Project Name:"
read -e pname

#note: check to see if there's already a folder in there already 

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

echo "Creating MYSQL stuff. MySQL admin password required."

MYSQL=`which mysql`

Q1="CREATE DATABASE IF NOT EXISTS $dbname;"
Q2="GRANT USAGE ON *.* TO $dbuser@localhost IDENTIFIED BY '$dbpass';"
Q3="GRANT ALL PRIVILEGES ON $dbname.* TO $dbuser@localhost;"
Q4="FLUSH PRIVILEGES;"

SQL="${Q1}${Q2}${Q3}${Q4}"

$MYSQL -uroot -p -e "$SQL"

echo "Running WP-CLI core config"
wp core config --dbname=$dbname --dbuser=$dbuser --dbpass=$dbpass

echo "Site title:"
read -e sitetitle

echo "WP-admin User:"
read -e adminuser

echo "WP-admin Password:"
read -e adminpassword

echo "WP-admin Email:"
read -e adminemail

echo "Running WP-CLI core install"
wp core install --url="http://localhost/$pname" --title="$sitetitle" --admin_user=$adminuser --admin_password=$adminpassword --admin_email=$adminemail

echo "Cleaning Up"
cd ..
rm latest.tar.gz


echo "========================="
echo "Installation is complete."
echo "========================="
fi
