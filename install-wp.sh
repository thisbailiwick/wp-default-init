#!/usr/bin/env bash

#todo: python not found
#gyp verb check python checking for Python executable "python2" in the PATH
#gyp verb `which` failed Error: not found: python2
#gyp verb `which` failed     at getNotFoundError (/Applications/MAMP/htdocs/personal/wpinittest/testing-theme/web/app/themes/testing-theme/node_modules/which/which.js:13:12)
#gyp verb `which` failed     at F (/Applications/MAMP/htdocs/personal/wpinittest/testing-theme/web/app/themes/testing-theme/node_modules/which/which.js:68:19)
#gyp verb `which` failed     at E (/Applications/MAMP/htdocs/personal/wpinittest/testing-theme/web/app/themes/testing-theme/node_modules/which/which.js:80:29)
#gyp verb `which` failed     at /Applications/MAMP/htdocs/personal/wpinittest/testing-theme/web/app/themes/testing-theme/node_modules/which/which.js:89:16
#gyp verb `which` failed     at /Applications/MAMP/htdocs/personal/wpinittest/testing-theme/web/app/themes/testing-theme/node_modules/isexe/index.js:42:5
#gyp verb `which` failed     at /Applications/MAMP/htdocs/personal/wpinittest/testing-theme/web/app/themes/testing-theme/node_modules/isexe/mode.js:8:5
#gyp verb `which` failed     at FSReqWrap.oncomplete (fs.js:166:21)
#gyp verb `which` failed  python2 { Error: not found: python2
#gyp verb `which` failed     at getNotFoundError (/Applications/MAMP/htdocs/personal/wpinittest/testing-theme/web/app/themes/testing-theme/node_modules/which/which.js:13:12)
#gyp verb `which` failed     at F (/Applications/MAMP/htdocs/personal/wpinittest/testing-theme/web/app/themes/testing-theme/node_modules/which/which.js:68:19)
#gyp verb `which` failed     at E (/Applications/MAMP/htdocs/personal/wpinittest/testing-theme/web/app/themes/testing-theme/node_modules/which/which.js:80:29)
#gyp verb `which` failed     at /Applications/MAMP/htdocs/personal/wpinittest/testing-theme/web/app/themes/testing-theme/node_modules/which/which.js:89:16
#gyp verb `which` failed     at /Applications/MAMP/htdocs/personal/wpinittest/testing-theme/web/app/themes/testing-theme/node_modules/isexe/index.js:42:5
#gyp verb `which` failed     at /Applications/MAMP/htdocs/personal/wpinittest/testing-theme/web/app/themes/testing-theme/node_modules/isexe/mode.js:8:5
#gyp verb `which` failed     at FSReqWrap.oncomplete (fs.js:166:21)

# Requires
# wp-cli http://wp-cli.org/
# composer https://getcomposer.org - composer calls below may need to be altered if composer is intalled globablly or not. This is using a global install.
# bower
# npm
# node

# commandline args are $1: theme name $2: db tables prefix (only contain numbers, letters, and underscores)  $3: devUrl $4: site title

# TODO: check if node, npm, yarn installed


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
# echo "$1"
# echo "${THEMENAME}"

# if dev url arg not set then make it the themename
if [ -z "$3" ]
then
  DEVURL=${1//[^a-zA-Z0-9]/-}
else
  DEVURL=${3//[^a-zA-Z0-9]/-}
fi

if [ -z "$4" ]
then
  SITETITLE=${THEMENAME}
else
  SITETITLE=${4}
fi


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
mv ./bedrock ./${THEMENAME}
cd ./${THEMENAME}

# Create .env file
cp ./.env.example ./.env

# Generate salts
wp package install aaemnnosttv/wp-cli-dotenv-command

wp dotenv salts regenerate

# add db values to .env
sed -i '' -e "s/database_name/${THEMENAME}/g" ./.env
sed -i '' -e "s/database_user/global/g" ./.env
sed -i '' -e "s/database_password/global/g" ./.env
sed -i '' -e "s/# DB_PREFIX=wp_/DB_PREFIX=${DBPREFIX}_/g" ./.env
sed -i '' -e "s/example.com/${DEVURL}.localhost/g" ./.env

# Add ACF
# composer config repositories.acf/advanced-custom-fields-pro '{\
#   "type": "package",\
#   "package": {\
#     "name": "acf/advanced-custom-fields-pro",\
#     "version": "5.6.7",\
#     "type": "wordpress-plugin",\
#     "dist": {\
#       "type": "zip",\
#       "url": "https://github.com/thisbailiwick/advanced-custom-fields-pro/archive/master.zip"\
#     },\
#     "require": {\
#       "composer/installers": "v1.5.0"\
#     }\
#   }\
# }'

composer config repositories.acf/advanced-custom-fields-pro '{   "type":"package",   "package":{      "name":"acf/advanced-custom-fields-pro",      "version":"5.6.7",      "type":"wordpress-plugin",      "dist":{         "type":"zip",         "url":"https://github.com/thisbailiwick/advanced-custom-fields-pro/archive/master.zip"      },      "require":{         "composer/installers":"v1.5.0"      }   }}'
# Add plugins
composer require roots/soil:* acf/advanced-custom-fields-pro:* wpackagist-plugin/acf-link-picker-field:* wpackagist-plugin/black-studio-tinymce-widget:* wpackagist-plugin/hide-my-site:*

# Pull in customized sage theme

# Add thisbailiwick/sage-default
#this is github zip
composer config repositories.thisbailiwick/sage-default '{  "type": "package",  "package": {    "name": "thisbailiwick/sage-default",    "version": "1.0",    "type": "wordpress-theme",    "dist": {      "type": "zip",      "url": "https://github.com/thisbailiwick/sage-default/archive/sage-default.zip"    },    "require": {      "composer/installers": "v1.5.0"    }  }}'

composer require thisbailiwick/sage-default:*
#composer create-project thisbailiwick/sage-default your-theme-name
#cd ./your-theme-name
cd ./web/app/themes/

mv ./sage-default ./${THEMENAME}
cd ./${THEMENAME}

echo ${DEVURL}

#spin up requirments for sage
yarn

#run composer install: need to do so (even though it doesn't say to in sage docs because we didn't use this to crate the theme: composer create-project roots/sage your-theme-name)
composer install

#change devUrl of theme
sed -i '' -e "s/example.test/${DEVURL}.localhost/g" ./resources/assets/config.json

npm install --save fitvids flickity video.js

# add host to MAMP

# quit MAMP
osascript -e 'quit app "MAMP PRO"'

while true; do
  read -n1 -rsp "Press 'c' to continue after MAMP closes compeletely......" key
  if [ "$key" = 'c' ];
  then
    echo
    break
  fi
done
echo '\nContinuing'

cd '../../../'
DIR="$( pwd )"
/Applications/MAMP\ PRO/MAMP\ PRO.app/Contents/MacOS/MAMP\ PRO cmd createHost "${DEVURL}.localhost" "${DIR}"
# /Applications/MAMP\ PRO/MAMP\ PRO.app/Contents/MacOS/MAMP\ PRO cmd stopServers
# /Applications/MAMP\ PRO/MAMP\ PRO.app/Contents/MacOS/MAMP\ PRO cmd startServers

#open mamp
open -a 'MAMP PRO'

# read -p "Press any key to continue after MAMP opens compeletely... " -n1 -s

while true; do
  read -n1 -rsp "Press 'c' to continue after MAMP completes opening (does not need to have php/mysql running)..." key
  if [ "$key" = 'c' ];
  then
    echo
    break
  fi
done

echo "\nRunning post mamp opening script"
#Running post mamp opening script
/Applications/MAMP\ PRO/MAMP\ PRO.app/Contents/MacOS/MAMP\ PRO cmd startServers

while true; do
  read -n1 -rsp "Press 'c' to continue after MAMP servers have started (make sure they're running!)..." key
  if [ "$key" = 'c' ];
  then
    echo
    break
  fi
done

echo "\nRunning post mamp servers start script"


# generate password
ADMINPASSWORD=date | md5sum
echo "admin pw: ${ADMINPASSWORD}"
# install wp
# todo: this does not work, get's db error
wp core install --url=${DEVURL}.localhost --title=${SITETITLE} --admin_user=roundhex --admin_email=tech+${THEMENAME}@steinhardtdesign.com --admin_password=${ADMINPASSWORD}
echo "\nrunning post wp core install script"
sleep 6

#open url in browser
open http://${DEVURL}.localhost


# read -n1 -rsp "Press 'c' to continue after MAMP completes opening and servers have started..." key

# if [ "$key" = 'c' ]; then
#   echo 'Continuing'
#
# else
#     # Anything else pressed, do whatever else.
#      echo [$key] not empty
# fi
