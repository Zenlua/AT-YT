# kakathic
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

checkYT
if [ "$(sha256sum "$(linkAPK)" | awk '{print $1}')" == "$(sha256sum "$MODPATH/base.apk" | awk '{print $1}')" ];then
ui_print2 "Mount YouTube"
ui_print
mountYT "$MODPATH/YouTube.apk" "$(linkAPK)"
ui_print2 "Turn off update"
ui_print
offCH
else
ui_print2 "Install YouTube"
installYT
ui_print
mountYT $MODPATH/YouTube.apk "$(linkAPK)"
ui_print2 "Turn off update"
ui_print
offCH
fi

if [ -z "$(pm path com.google.android.youtube)" ];then
ui_print2 "Failure, Can't install YouTube !"
ui_print
else
ui_print2 "Complete"
ui_print
fi

exit 0
