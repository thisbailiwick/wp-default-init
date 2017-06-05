#!/usr/bin/env bash

# Requires
# wp-cli http://wp-cli.org/
# composer https://getcomposer.org

mkdir bedrock && cd ./bedrock
# Pull in Bedrock
composer create-project roots/bedrock
ls
ls ./bedrock
cd ./bedrock
pwd
ls

# Create .env file
cp ./.env.example ./.env

# Generate salts
wp package install aaemnnosttv/wp-cli-dotenv-command

wp dotenv salts regenerate

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

mv ./sage-default ./your-theme-name
cd ./your-theme-name

npm install
bower install

bower install --save fitvids flickity jplayer
