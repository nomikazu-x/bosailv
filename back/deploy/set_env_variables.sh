#!/bin/zsh

echo DB_HOST=$DB_HOST >> back/.env &&
echo DB_DATABASE=$DB_DATABASE >> back/.env &&
echo DB_USERNAME=$DB_USERNAME >> back/.env &&
echo DB_PASSWORD=$DB_PASSWORD >> back/.env &&
echo APP_NAME=$APP_NAME >> back/.env &&
echo APP_KEY=$APP_KEY >> back/.env &&
echo APP_ENV=$APP_ENV >> back/.env &&
echo APP_DEBUG=$APP_DEBUG >> back/.env &&
echo 'Backend env variables configured'
