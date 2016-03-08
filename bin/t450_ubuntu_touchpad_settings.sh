#!/bin/bash

TOUCHPAD="SynPS/2 Synaptics TouchPad"
pkill syndaemon
xinput set-prop "$TOUCHPAD" "Synaptics Palm Detection" 1
syndaemon -i 1.0 -K -R -d
