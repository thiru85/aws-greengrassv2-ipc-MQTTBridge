#!/bin/bash
# This should deploy well on a Raspberry Pi
. /etc/os-release

if [[ ! -d $1/manifest ]]; then
      mkdir -p $1/manifest
fi

if [[ ! -d $1/lists ]]; then
      mkdir -p $1/lists
fi

if [[ $VERSION_ID = "9" ]]; then
      VER="stretch"
elif [[ $VERSION_ID = "10" ]]; then
      VER="buster"
fi

curl http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key -o $1/manifest/mosquitto-repo.gpg.key

apt-key add $MosquittoRoot/manifest/mosquitto-repo.gpg.key

curl http://repo.mosquitto.org/debian/mosquitto-$VER.list -o $1/lists/mosquitto-$VER.list

cp $MosquittoRoot/lists/mosquitto-stretch.list /etc/apt/sources.list.d/

apt-get update
apt-get install mosquitto mosquitto-clients --yes

systemctl stop mosquitto.service

MOSQUITTO_PORT=1883
MQTT_BROKER_IP='0.0.0.0'

touch /etc/mosquitto/conf.d/local.conf

cat /dev/null > /etc/mosquitto/conf.d/local.conf

echo -e "\nlistener $MOSQUITTO_PORT $MQTT_BROKER_IP\nallow_anonymous true\n" >> /etc/mosquitto/conf.d/local.conf

systemctl start mosquitto.service