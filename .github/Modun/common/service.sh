# kakathic
MODPATH="${0%/*}"
. $MODPATH/YT.sh

while true; do
[ "$(getprop sys.boot_completed)" == 1 ] && break || sleep 2
done
sleep 10

if [ "$(sha256sum "$(linkAPK)" | awk '{print $1}')" == "$(sha256sum "$MODPATH/base.apk" | awk '{print $1}')" ];then
mountYT "$MODPATH/YouTube.apk" "$(linkAPK)"
offCH
else
installYT
mountYT "$MODPATH/YouTube.apk" "$(linkAPK)"
offCH
fi
