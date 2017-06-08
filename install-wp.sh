#!/usr/bin/env bash

# Requires
# wp-cli http://wp-cli.org/
# composer https://getcomposer.org - composer calls below may need to be altered if composer is intalled globablly or not. This is using a global install.


# Create a db
# create random password
#PASSWDDB="$(openssl rand -base64 12)"
PASSWDDB="global"
PASSWDMSYQL="root"

if [ -z "$2" ]
then
  DBPREFIX="wprx"
else
  DBPREFIX="$2"
fi

# replace "-" with "_" for database name
if [ -z "$1" ]
then
  THEMENAME="your-theme-name"

else
  THEMENAME=${1//[^a-zA-Z0-9]/-}
fi
echo "$1"
echo "${THEMENAME}"


# /Applications/MAMP/Library/bin/mysql --host=localhost -uroot -proot
# CREATE DATABASE ${THEMENAME} /*\!40100 DEFAULT CHARACTER SET utf8 */;
# GRANT ALL PRIVILEGES ON ${THEMENAME}.* TO 'global'@'localhost';
# FLUSH PRIVILEGES;
# exit

#If /root/.my.cnf exists then it won't ask for root password
if [ -f /root/.my.cnf ]; then

    mysql -e "CREATE DATABASE IF NOT EXISTS \`${THEMENAME}\` /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    #mysql -e "CREATE USER ${MAINDB}@localhost IDENTIFIED BY '${PASSWDDB}';"
    #mysql -e "GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${MAINDB}'@'localhost';"
    mysql -e "GRANT ALL PRIVILEGES ON \`${THEMENAME}\`.* TO 'global'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"

# If /root/.my.cnf doesn't exist then it'll ask for root password
else
    # echo "Please enter root user MySQL password!"
    # read rootpasswd

    /Applications/MAMP/Library/bin/mysql --host=localhost -u "root" -p"${PASSWDMSYQL}" -e "CREATE DATABASE IF NOT EXISTS \`${THEMENAME}\` /*\!40100 DEFAULT CHARACTER SET utf8 */;"

    #mysql -uroot -p${rootpasswd} -e "CREATE USER ${THEMENAME}@localhost IDENTIFIED BY '${PASSWDDB}';"
    /Applications/MAMP/Library/bin/mysql --host=localhost -u "root" -p"${PASSWDMSYQL}" -e "GRANT ALL PRIVILEGES ON \`${THEMENAME}\`.* TO 'global'@'localhost';"
    /Applications/MAMP/Library/bin/mysql --host=localhost -u "root" -p"${PASSWDMSYQL}" -e "FLUSH PRIVILEGES;"
fi

# mkdir bedrock && cd ./bedrock
# Pull in Bedrock
composer create-project roots/bedrock
cd ./bedrock

# Create .env file
cp ./.env.example ./.env

# Generate salts
wp package install aaemnnosttv/wp-cli-dotenv-command

wp dotenv salts regenerate

# add db values to .env
sed -i .tmp -e "s/database_name/${THEMENAME}/g" ./.env
sed -i .tmp -e "s/database_user/global/g" ./.env
sed -i .tmp -e "s/database_password/global/g" ./.env
sed -i .tmp -e "s/# DB_PREFIX=wp_/DB_PREFIX=${DBPREFIX}_/g" ./.env
sed -i .tmp -e s/example\.com/${THEMENAME}\.localhost/g ./.env

# the above duplicates .env
rm ./.env
mv ./.env.tmp ./.env

# Add ACF
# composer config repositories.acf/advanced-custom-fields-pro '{\
#   "type": "package",\
#   "package": {\
#     "name": "acf/advanced-custom-fields-pro",\
#     "version": "5.5.11",\
#     "type": "wordpress-plugin",\
#     "dist": {\
#       "type": "zip",\
#       "url": "https://github.com/wp-premium/advanced-custom-fields-pro/archive/master.zip"\
#     },\
#     "require": {\
#       "composer/installers": "v1.2.0"\
#     }\
#   }\
# }'

composer config repositories.acf/advanced-custom-fields-pro '{   "type":"package",   "package":{      "name":"acf/advanced-custom-fields-pro",      "version":"5.5.11",      "type":"wordpress-plugin",      "dist":{         "type":"zip",         "url":"https://github.com/wp-premium/advanced-custom-fields-pro/archive/master.zip"      },      "require":{         "composer/installers":"v1.2.0"      }   }}'
# Add plugins
composer require roots/soil:* acf/advanced-custom-fields-pro:* wpackagist-plugin/acf-link-picker-field:* wpackagist-plugin/black-studio-tinymce-widget:* wpackagist-plugin/hide-my-site:*

# Pull in customized sage theme

# Add thisbailiwick/sage-default
#this is github zip
composer config repositories.thisbailiwick/sage-default '{  "type": "package",  "package": {    "name": "thisbailiwick/sage-default",    "version": "1.0",    "type": "wordpress-theme",    "dist": {      "type": "zip",      "url": "https://github.com/thisbailiwick/sage-default/archive/master.zip"    },    "require": {      "composer/installers": "v1.2.0"    }  }}'

composer require thisbailiwick/sage-default:*
#composer create-project thisbailiwick/sage-default your-theme-name
#cd ./your-theme-name
cd ./web/app/themes/

mv ./sage-default ./${THEMENAME}
cd ./${THEMENAME}

npm install
bower install

bower install --save fitvids flickity jplayer
