# load dữ liệu 
lib1="revanced-cli.jar"
lib2="revanced-patches.jar"

pbsta(){
Vurl="$(curl -s https://api.github.com/repos/inotia00/$1/releases/latest | grep 'browser_download_url.*.'$2'"' | cut -d\" -f4)"
Taive "$Vurl" "$1.jar"; 
echo "- Url: $Vurl
"; }
 
# tải tool dev
pbdev(){
Vsion1="$(Xem https://github.com/inotia00/$1/releases | grep -om1 'inotia00/'$1'/releases/tag/.*dev' | cut -d '"' -f1 | sed -e 's|dev|zzz|g' -e 's|v||g' -e 's|zzz|dev|g' -e 's|\"||g')"
Taive "https://github.com/inotia00/$1/releases/download/v${Vsion1##*/}/$2-${Vsion1##*/}$4.$3" "$1.jar"; 
echo "- Url: https://github.com/inotia00/$1/releases/download/v${Vsion1##*/}/$2-${Vsion1##*/}$4.$3
"; }

# tải apk
TaiYT(){
urrl="https://www.apkmirror.com"
uak1="$urrl$(Xem "$urrl/apk/$2" | grep -m1 'downloadButton' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
uak2="$urrl$(Xem "$uak1" | grep -m1 '>here<' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2 | sed 's|amp;||')"
Taive "$uak2" "apk/$1"
echo "Link: $uak2"
# file check
file "apk/$1" | tee "apk/$1.txt";
}

# Load dữ liệu cài đặt 
. $HOME/.github/options/Ytx.md

# Tải tool cli
echo "- Tải tool cli, patches, integrations..."
if [ "$DEV" == "Develop" ];then
echo "  Dùng Dev"
echo
pbdev revanced-cli revanced-cli jar -all
pbdev revanced-patches patches rvp
else
echo "  Dùng Sta"
echo
pbsta revanced-cli jar
pbsta revanced-patches rvp
fi

# kiểm tra tải tool
checkzip "$lib1"
checkzip "$lib2"
echo

# lấy dữ liệu phiên bản mặc định
echo "- Kiểm tra bản YouTube mới nhất..."
Vidon="$(java -Djava.io.tmpdir=$HOME -jar $lib1 list-versions $lib2 -f com.google.android.youtube | grep -w '(.*.)' | sort -n | tail -1 | awk '{print $1}')"; 
echo "  $Vidon"
echo

if [ "$VERSION" == 'Auto' ];then
VER="$Vidon"
Kad=Build
V=V
elif [ "$VERSION" == 'Autu' ];then
VER="$Vidon"
Kad=Auto
V=U
else
#Vidon="$VERSION"
VER="$VERSION"
Kad=Edit
V=N
fi

Upenv V "$V"
Upenv Kad "$Kad"
Upenv VER "$VER"

if [[ "$VERSION" == 'Autu' ]] && [[ "$(Xem https://github.com/$GITHUB_REPOSITORY/releases/download/Up/Up-X${V}notes.json | grep -cm1 "${VER//./}")" == 1 ]];then
echo "! Là phiên bản mới nhất."
gh run cancel $GITHUB_RUN_ID
sleep 10
exit 0
fi

# là amoled
[ "$AMOLED" == 'true' ] && amoled2='-Amoled'
[ "$AMOLED" == 'true' ] || theme='-d Theme'
[ "$TYPE" == 'true' ] && Mro='-d "GmsCore support"'

# Xoá lib dựa vào abi
if [ "$DEVICE" == "arm64-v8a" ];then
lib="lib/x86/* lib/x86_64/* lib/armeabi-v7a/*"
ach="arm64"
elif [ "$DEVICE" == "x86" ];then
lib="lib/x86_64/* lib/arm64-v8a/* lib/armeabi-v7a/*"
ach="x86"
elif [ "$DEVICE" == "x86_64" ];then
lib="lib/x86/* lib/arm64-v8a/* lib/armeabi-v7a/*"
ach="x64"
else
lib="lib/arm64-v8a/* lib/x86/* lib/x86_64/*"
ach="arm"
fi

echo "- Tải YouTube $VER apk, apks..."
# Tải YouTube apk
kkk1="google-inc/youtube/youtube-${VER//./-}-release/youtube-${VER//./-}-2-android-apk-download"
kkk2="google-inc/youtube/youtube-${VER//./-}-release/youtube-${VER//./-}-android-apk-download"

# Tải
TaiYT 'YouTube1' "$kkk1" & TaiYT 'YouTube2' "$kkk2"

# Chờ tải xong
Loading apk/YouTube1.txt apk/YouTube2.txt

# Xem xét apk
[ "$(file apk/YouTube1 | grep -cm1 HTML)" == 1 ] && rm -fr apk/YouTube1
[ "$(file apk/YouTube2 | grep -cm1 HTML)" == 1 ] && rm -fr apk/YouTube2

echo
if [ -e apk/YouTube1 ];then
if [ "$(unzip -l apk/YouTube1 | grep -cm1 'base.apk')" == 1 ];then
echo "- apk1 thành apks."
mv apk/YouTube1 apk/YouTube.apks
else
echo "- apk1 thành apk."
mv apk/YouTube1 apk/YouTube.apk
fi
else
echo "- không có file apk1"
fi

if [ -e apk/YouTube2 ];then
if [ "$(unzip -l apk/YouTube2 | grep -cm1 'base.apk')" == 1 ];then
echo "- apk2 thành apks."
mv apk/YouTube2 apk/YouTube.apks
else
echo "- apk2 thành apk."
mv apk/YouTube2 apk/YouTube.apk
fi
else
echo "- không có file apk2"
fi


if [ "$TYPE" == 'true' ];then
lib='lib/*/*'
if [ -e apk/YouTube.apks ];then
echo "- Giải nén base.apk"
unzip -qo apk/YouTube.apks 'base.apk' "split_config.${DEVICE//-/_}.apk" split_config.xxhdpi.apk -d Tav   
else
echo "- Giải nén Lib"
cp apk/YouTube.apk Tav/base.apk
fi
unzip -qo apk/YouTube.apk lib/$DEVICE/* -d tmp
fi

# Copy 
echo > $HOME/.github/Modun/common/$ach
cp -rf $HOME/.github/Tools/sqlite3_$ach $HOME/.github/Modun/common/sqlite3

echo "- Xoá lib thừa."
echo
zip -qr apk/YouTube.apk -d $lib

# Xử lý revanced patches
if [ "$Vidon" != "$VER" ];then
echo "- Chuyển đổi phiên bản $VER"
unzip -qo "$lib2" -d $HOME/jar
for vak in $(grep -Rl "$Vidon" $HOME/jar); do
cp -rf $vak test
XHex test | sed -e "s/$(echo -n "$Vidon" | XHex)/$(echo -n "$VERSION" | XHex)/" | ZHex > $vak
done
cd $HOME/jar
rm -fr $lib2
zip -qr "$HOME/$lib2" *
cd $HOME
fi

# MOD YouTube 
echo "▼ Bắt đầu quá trình xây dựng..."
eval "java -Djava.io.tmpdir=$HOME -jar $lib1 patch -p $lib2 apk/YouTube.apk -o YT.apk "$Tof $Ton $Mro $theme $feature""
echo '- Quá trình xây dựng apk xong.'
echo

ls YT-temporary-files/*.apk
cp -rf YT-temporary-files/*.apk YT2.apk

if [ "$TYPE" == 'true' ];then
echo "Tạo rsign..."
echo
mv YT.apk $HOME/Tav/YouTube.apk
cd tmp
zip -qr $HOME/YT2.apk *
cd $HOME
rsign Tav/base.apk YT2.apk $HOME/Up/ZXT-$VER-$ach${amoled2}-rsign.apk
else
apksign YT.apk $HOME/Up/XYT-$VER-$ach${amoled2}.apk
ls Up
exit 0
fi
cd Tav
tar -cf - * | xz -9kz > $HOME/.github/Modun/common/lib.tar.xz
cd $HOME

# Tạo module.prop
echo 'id=YouTube
name=YouTube Ext '$Kad'
author=kakathic
description=Build '$date', YouTube edited tool by Revanced mod added disable play store updates.
version='$VER'
versionCode='${VER//./}'
updateJson=https://github.com/'$GITHUB_REPOSITORY'/releases/download/Up/Up-X'$V$ach$amoled2'.json
' > $HOME/.github/Modun/module.prop

# Tạo json
echo '{
"version": "'$VER'",
"versionCode": "'${VER//./}'",
"zipUrl": "https://github.com/'$GITHUB_REPOSITORY'/releases/download/X'$V$VER'/XYT-Hybrid-'$VER'-'$ach$amoled2'.Zip",
"changelog": "https://github.com/'$GITHUB_REPOSITORY'/releases/download/Up/Up-X'$V'notes.json"
}' > "Up-X$V$ach$amoled2.json"

echo -e 'Update '$date' \nYouTube: '$VER' \nVersion: '${VER//./}'\nAuto by kakathic' > Up-X${V}notes.json

Upenv BODY "Update $date, YouTube: $VER, Version: ${VER//./}, Auto by kakathic"

# Tạo module magisk
cd $HOME/.github/Modun
zip -qr $HOME/Up/XYT-Hybrid-$VER-$ach$amoled2.zip *
cd $HOME
ls Up
