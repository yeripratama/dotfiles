#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# start some nice programs {{{
# keyboard speed
xset r rate 250 60
# caps lock to escape
setxkbmap -option caps:swapescape
# setxkbmap -option ctrl:nocaps
# }}}

# Here i3 is kept as default
session=${1:-xfce}

case $session in
    i3|i3wm )
        exec i3
        ;;

    # cinnamon )
    #     exec cinnamon-session
    #     ;;

    xfce )
        exec startxfce4
        ;;

    # No known session, try to run it as command
    * ) exec $1;;
esac
