# kakathic
MODPATH="${0%/*}"
rm -fr $MODPATH/YouTube/*

while true; do
[ "$(getprop sys.boot_completed)" == 1 ] && break || sleep 2
done
. $MODPATH/YT.sh
sleep 10

if [ "$(ls -l $(linkAPK) | awk '{print $5}')" == "$(cat $MODPATH/SIZE)" ];then
mountYT "$MODPATH/YouTube.apk" "$(linkAPK)"
offCH
else
installYT
ls -l "$MODPATH/YouTube.apk" | awk '{print $5}' > $MODPATH/SIZE
mountYT $MODPATH/YouTube.apk "$(linkAPK)"
offCH
fi
