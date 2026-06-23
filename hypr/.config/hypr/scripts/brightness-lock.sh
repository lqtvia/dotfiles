#!/bin/bash
CURRENT=$(brightnessctl get)
brightnessctl set 20%
hyprlock
brightnessctl set $CURRENT
