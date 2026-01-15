# KAKATHIC

# Để true để bỏ qua Mount system
SKIPMOUNT=true
# Để true nó sẽ kết hợp system.prop vào build.prop
PROPFILE=false
# Để true post-fs-data.sh được sử dụng
POSTFSDATA=false
# Để true để service.sh được sử dụng
LATESTARTSERVICE=true

# Giống như echo
ui_print2 () { echo "    $1"; sleep 0.005; }
ui_print () { echo "$1"; sleep 0.005; }
. $TMPDIR/YT.sh

# Lấy dữ liệu
Getp () { grep_prop $1 $TMPDIR/module.prop; }
settings put global package_verifier_enable 0

# Giới thiệu
print_modname() {
ui_print
ui_print2 "Name: $(Getp name)"
ui_print
ui_print2 "Version: $(Getp version)"
ui_print
ui_print2 "Author: $(Getp author)"
ui_print
}

# Bắt đầu cài đặt
on_install(){
[ -e "$TMPDIR/$ARCH" ] || abort "    This module only supports $ARCH devices
"
ui_print2 "Processing"
ui_print
# Giải nén
cp -f $TMPDIR/sqlite3 $MODPATH/sqlite3 >&2
cp -f $TMPDIR/YT.sh $MODPATH >&2
cp -f $TMPDIR/action.sh $MODPATH >&2
chmod -R 755 $MODPATH/sqlite3
mkdir -p $MODPATH/YouTube

checkYT
ui_print2 "Install YouTube"
ui_print
tar -xJf $TMPDIR/lib.tar.xz -C $MODPATH
installYT
ui_print2 "Mount YouTube"
ui_print
mountYT $MODPATH/YouTube.apk "$(linkAPK)"

ui_print2 "Turn off update"
ui_print
offCH

[ "$(Getp author)" == "$(echo -n 'a2FrYXRoaWM=' | base64 -d)" ] || abort "Copyright infringement"
if [ -z "$(pm path com.google.android.youtube)" ];then
ui_print2 "Failure"
ui_print
abort
fi

ui_print2 "Complete"
ui_print

}

# Cấp quyền
set_permissions(){
set_perm_recursive $MODPATH 0 0 0755 0644
chmod -R 755 $MODPATH/sqlite3
}
