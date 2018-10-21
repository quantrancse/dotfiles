#!/bin/sh

# Load Resources
[[ -f $HOME/.Xresources ]] && xrdb -I$HOME -merge $HOME/.Xresources
#$HOME/bin/loadresources

# Speed and mouse pointer
xset m 3

# Beep sound
xset b 15 200 150

# Screen saver 60 mins
xset s off
xset dpms 3600 3600 3600

# Font dir
xset fp+ $HOME/.fonts/misc
xset fp+ $HOME/.fonts/ohsnap
xset fp+ $HOME/.fonts/terminesspowerline
xset fp+ $HOME/.fonts/tewi
fc-cache -v

# Background
[[ -f $HOME/.fehbg ]] && sh $HOME/.fehbg

# Program for i3
#exec conky -c ~/.i3/conkyrc &
#exec nm-applet &

# Notification 
exec /usr/lib/notification-daemon/notification-daemon &

# Remap the extended mouse buttons
# Package xinput
# "xinput list" -> shows devices
# Change the Wheel Left (6) by the Middle click (2)
xinput set-button-map 10 1 2 3 4 5 2 7 8 9

xmodmap -e "clear lock" #disable caps lock switch
xmodmap -e "keysym Caps_Lock = Escape" #set caps_lock as escape

# Window Manager
exec i3
