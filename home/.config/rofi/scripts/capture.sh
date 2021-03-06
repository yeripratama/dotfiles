#!/usr/bin/env bash

recording_pidfile=/tmp/recording.pid
recording_savepath=/tmp/recording.path
logfile=/tmp/recording.log

# rofi_command="rofi -theme themes/capture.rasi -dmenu"
# TODO broken theme after upgrade to 1.6.0
rofi_command="rofi -dmenu"

capture_full () {
    mkdir -p ~/Pictures/shots
    maim ~/Pictures/shots/capture-$(date +%s).png
}

capture_area () {
    mkdir -p ~/Pictures/shots
    maim -s ~/Pictures/shots/capture-$(date +%s).png
}

capture_window () {
    mkdir -p ~/Pictures/shots
    maim -i $(xdotool getactivewindow) ~/Pictures/shots/capture-$(date +%s).png
}

record_screencast () {
    savedir="$HOME/Videos/screencasts"
    savefile="$savedir/screencast-$(date '+%y%m%d-%H%M-%S').mp4"

    mkdir -p $savedir

    ffmpeg -y \
        -f x11grab \
        -framerate 30 \
        -s $(xrandr | grep '*' | awk '{print $1;}') \
        -i :0.0+0,0 \
        -f pulse -i default \
        -c:v libx264 \
        -threads 4 \
        $savefile >> $logfile 2>&1 &

    echo $! > $recording_pidfile
    echo $savefile > $recording_savepath

    # -f pulse -i alsa_output.pci-0000_00_1b.0.analog-stereo.monitor \
    # -f pulse -i alsa_input.pci-0000_00_1b.0.analog-stereo \
    # -filter_complex amix=inputs=2 \
    # -c:a aac \
    # -c:v libx264 -pix_fmt yuv420p -qp 18 -q:v 1 \
}

record_video () {
    savedir="$HOME/Videos/screencasts"
    savefile="$savedir/recording-$(date '+%y%m%d-%H%M-%S').mp4"

    mkdir -p $savedir

    ffmpeg \
        -f x11grab \
        -framerate 30 \
        -s $(xrandr | grep '*' | awk '{print $1;}') \
        -i :0.0+0,0 \
        -c:v libx264 -pix_fmt yuv420p -preset veryfast -q:v 1 \
        -threads 4 \
        $savefile >> $logfile 2>&1 &

    echo $! > $recording_pidfile
    echo $savefile > $recording_savepath
}

record_audio () {
    savedir="$HOME/Music/recordings"
    savefile="$savedir/recording-$(date '+%y%m%d-%H%M-%S').flac"

    mkdir -p $savedir

    ffmpeg \
        -f pulse -i default \
        -c:a flac \
        $savefile &

    echo $! > $recording_pidfile
    echo $savefile >> $logfile 2>&1 &
}

stop_recording () {
    notify-send "Recording Finished!" "File saved to $(cat "$recording_savepath")"
    pid="$(cat $recording_pidfile)"
    # kill with SIGTERM, allowing finishing touches.
    kill -15 "$pid"
    rm -f $recording_pidfile $recording_savepath
    t
}

confirm_end () {
    yes=""
    no=""
    response=$(echo -e "$no\n$yes" | $rofi_command -p "Stop Recording?")

    if [[ "$response" = "$yes" ]]; then
        stop_recording
    fi
}

show_menu () {
    if [[ -f $recording_pidfile ]]; then
        confirm_end
        exit
    fi

    screencast=""
    video=""
    audio=""
    capture_full=""
    capture_area=""
    capture_window=""

    screencast="screencast"
    video="video"
    audio="audio"
    capture_full="screenshot full"
    capture_area="screenshot crop"
    capture_window="screenshot window"

    choice=$(echo -e "$screencast\n$video\n$audio\n$capture_full\n$capture_area\n$capture_window" | $rofi_command -p "Capture")

    case "$choice" in
        $screencast) record_screencast;;
        $video) record_video;;
        $audio) record_audio;;
        $capture_full) sleep 1; capture_full;;
        $capture_area) capture_area;;
        $capture_window) sleep 1; capture_window;;
    esac
}

action=$1
case "$action" in
  "screencast") record_screencast;;
  "audio") record_audio;;
  "video") record_video;;
  "capture_full") capture_full;;
  "capture_area") capture_area;;
  "capture_window") capture_window;;
  *) show_menu;;
esac
