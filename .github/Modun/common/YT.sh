# kakathic

linkAPK(){ find /data/app | grep com.google.android.youtube | grep -m1 'base.apk'; }

checkYT(){
for vv in $(find /data/app -maxdepth 2 -type d | grep com.google.android.youtube); do
umount -l "$vv" &>/dev/null;
rm -fr "$vv"
done
[ -d "/data/YouTube/tmp" ] && umount -l /data/YouTube/tmp &>/dev/null;
}

installYT(){
chcon u:object_r:apk_data_file:s0 $MODPATH/*.apk
patpk="$(ls -1 $MODPATH/*.apk | sed '/YouTube.apk/d')"
[ $(pm install -r $patpk | grep -cm1 'Success') == 1 ] && inYT="done" || inYT="failure"
[ "$inYT" == "failure" ] && pm uninstall com.google.android.youtube &>/dev/null
[ $(pm install -r $patpk | grep -cm1 'Success') == 1 ] && inYT="done" || inYT="failure"
[ "$inYT" == "done" ] || echo "- Error cannot install apk"; }

mountYT(){
if [ -d "${2%/*}" ];then
cp -af "${2%/*}"/* "$MODPATH/YouTube";
mount -t tmpfs -o size=200m YouTube "${2%/*}";
cp -af "$MODPATH/YouTube.apk" "$MODPATH/YouTube/base.apk";
mv $MODPATH/YouTube/* "${2%/*}";
chcon u:object_r:apk_data_file:s0 "${2%/*}"/*.apk;
fi; }

offCH(){
Sqlite3=$MODPATH/sqlite3
PS=com.android.vending
DB=/data/data/$PS/databases
LDB=$DB/library.db
LADB=$DB/localappstate.db
PK=com.google.android.youtube
cmd appops set --uid $PS GET_USAGE_STATS ignore
pm disable $PS &>/dev/null
$Sqlite3 $LDB "UPDATE ownership SET doc_type = '25' WHERE doc_id = '$PK'";
$Sqlite3 $LADB "UPDATE appstate SET auto_update = '2' WHERE package_name = '$PK'";
rm -rf /data/data/$PS/cache/*
am force-stop $PK &>/dev/null
pm enable $PS &>/dev/null; }
