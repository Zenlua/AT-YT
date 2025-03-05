# kakathic
RD="$RANDOM"
MODPATH="${0%/*}"
. $MODPATH/YT.sh

ui_print2 () { echo "  $1"; sleep 0.005; }
ui_print () { echo "$1"; sleep 0.005; }
Getp () { grep -m1 $1 $MODPATH/module.prop | cut -d= -f2; }

ui_print
ui_print2 "Name: $(Getp name)"
ui_print
ui_print2 "Version: $(Getp version)"
ui_print
ui_print2 "Author: $(Getp author)"
ui_print
ui_print2 "Install YouTube"
ui_print
if [ "$(ls -l $(linkAPK) | awk '{print $5}')" == "$(cat $MODPATH/SIZE)" ];then
ui_print2 "Mount YouTube"
ui_print
mountYT "$MODPATH/YouTube.apk" "$(linkAPK)"
ui_print2 "Copy lib"
ui_print
[ -e $MODPATH/lib ] && cpLIB $MODPATH/lib "$(linkAPK)"
ui_print2 "Turn off update"
ui_print
offCH
ui_print2 "Complete"
ui_print
else
installYT $MODPATH/base.apk
ls -l "$MODPATH/YouTube.apk" | awk '{print $5}' > $MODPATH/SIZE
ui_print2 "Copy lib"
ui_print
cpLIB $MODPATH/lib "$(linkAPK)"
ui_print2 "Mount YouTube"
ui_print
mountYT $MODPATH/YouTube.apk "$(linkAPK)"
ui_print2 "Turn off update"
ui_print
offCH
ui_print2 "Complete"
ui_print
fi

if [ -z "$(pm path com.google.android.youtube)" ];then
ui_print2 "Failure, Can't install YouTube !"
ui_print
else
ui_print2 "YouTube is open..."
ui_print
sleep 1
am start com.google.android.youtube >&2
fi

exit 0
