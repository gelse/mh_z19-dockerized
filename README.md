# mh_z19-dockerized
dockerized co2 sensor which reports to MQTT using mh_z19, based on debian:stable-slim
size: less than 120 mb

## How-To
- create or download the image (tbd: upload image to dockerhub)
- prepare your raspberry pi (see below)
- start image in privileged mode (needed for access to serial)

## How do i get the image
currently sadly you have to build it yourself, the Dockerfile is included

## How do i prepare my Raspberry Pi
you have to do three things:
- physically connect the mh_z19
- enable the UART serial device
- disable (!) any console that is using said device
### How do i physically connect the mh_z19 / cables?
- see https://pypi.org/project/mh-z19/ for now, i will update the description here later.
### How do i enable the UART serial device and disable the console ?
depends on which distribution you are running, but in dietpi you can do it via the following steps:
```
sudo dietpi-config
-> 4  : Advanced Options
-> Serial/UART : Mange available devices
-> ttyS0 console : [Off]
-> ttyS0 (mini URAT) device: [On]
<Ok>
<Reboot>
```
## How do i run the image
To have access to the serial device you have to mount it as a device and the container must run in privileged mode.
If someone knows a better, cleaner, more secure way, please let me know and/or create a PR.

## How can i configure the image ?
There are a few environment variables that are configured in /init:
### LABEL
- optional
- default co2pi
- this is the name with which the mqtt client connects to the mqtt server and also part of the topic
### INTERVAL
- optional
- default 120
- this is the interval in which the mh_z19 gets queried
### MQTT_SERVER
- mandatory
- no default
- this is the mqtt server to which the readings are reported
### HEALTHCHECKURL
- optional
- no defaut
- this is an URL where the script just sets a query each time it polls
### SERIAL_DEVICE
- optional
- default /dev/serial0
- this is the device that gets queried

## How can i get it into HomeAssistant ?
add the following to your configuration.yaml:
``´
 - platform: "mqtt"
    state_topic: "custom/<LABEL>/value"
    json_attributes_topic: "custom/<LABEL>/state"
    unit_of_measurement: "ppm"
    device_class: "carbon_dioxide"
    name: "Co2 Room A"
    unique_id: "co2rooma"
´``
and replace <LABEL> with the content of the environment variable above (or 'co2pi' without the quotes for default)
Also 'name' and 'unique_id' are of course variable as you wish.

## Something is wrong, how can i debug the container
run
`docker run --rm -it -e MQTT_SERVER=<my_mqtt_server> -v /dev/serial0:/dev/serial0 --privileged co2pi /bin/bash`
then you land in a bash in the container.
