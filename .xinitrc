setxkbmap -option ctrl:nocaps

xset r rate 300 50

# Make the X11 environment available to systemd/D-Bus services.
systemctl --user import-environment DISPLAY XAUTHORITY
dbus-update-activation-environment --systemd DISPLAY XAUTHORITY

exec i3
