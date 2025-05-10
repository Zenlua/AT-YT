# load dữ liệu 
lib1="lib/revanced-cli.jar"
lib2="lib/revanced-patches.jar"

# Tải tool sta
pbsta(){
Vurl="$(curl -s https://api.github.com/repos/ReVanced/$1/releases/latest | grep 'browser_download_url.*.'$2'"' | cut -d\" -f4)"
Taive "$Vurl" "lib/$1.jar"; 
echo "- Url: $Vurl
"; }
 
# tải tool dev
pbdev(){
Vsion1="$(Xem https://github.com/ReVanced/$1/releases | grep -om1 'ReVanced/'$1'/releases/tag/.*dev' | cut -d '"' -f1 | sed -e 's|dev|zzz|g' -e 's|v||g' -e 's|zzz|dev|g' -e 's|\"||g')"
Taive "https://github.com/ReVanced/$1/releases/download/v${Vsion1##*/}/$2-${Vsion1##*/}$4.$3" "lib/$1.jar"; 
echo "- Url: https://github.com/ReVanced/$1/releases/download/v${Vsion1##*/}/$2-${Vsion1##*/}$4.$3
"
}

# Tải json
if [ "$DEV" == "Develop" ];then
Vop='-DEV'
Vop2=D
fi

# tải apk
TaiYT(){
urrl="https://www.apkmirror.com"
uak1="$urrl$(Xem "$urrl/apk/$2" | grep -m1 'downloadButton' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
uak2="$urrl$(Xem "$uak1" | grep -m1 '>here<' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2 | sed 's|amp;||')"
Taive "$uak2" "apk/$1"
echo "Link: $uak2"
# file check
file "apk/$1" | tee "apk/$1.txt"; }

# Load dữ liệu cài đặt 
. $HOME/.github/options/YouTube.md

# là amoled
[ "$AMOLED" == 'true' ] && amoled2='-Amoled'
[ "$AMOLED" == 'true' ] || theme='-d "Theme"'
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

echo
# kiểm tra tải tool
checkzip "$lib1"
checkzip "$lib2"
echo

# kiểm tra phiên bản 
echo "- Kiểm tra bản YouTube mới nhất..."
Vidon="$(java -Djava.io.tmpdir=$HOME -jar $lib1 list-versions $lib2 -f com.google.android.youtube | grep -w '(.*.)' | sort -n | tail -1 | awk '{print $1}')";   
echo "  $Vidon"
echo

if [ "$VERSION" == 'Auto' ];then
VER="$Vidon"
Kad=Build$Vop
V=V$Vop2
elif [ "$VERSION" == 'Autu' ];then
VER="$Vidon"
Kad=Auto$Vop
V=U$Vop2
else
#Vidon="$VERSION"
VER="$VERSION"
Kad=Edit$Vop
V=N$Vop2
fi

Upenv V "$V"
Upenv Kad "$Kad"
Upenv VER "$VER"

if [[ "$VERSION" == 'Autu' ]] && [[ "$(Xem https://github.com/$GITHUB_REPOSITORY/releases/download/Up/Up-K${V}notes.json | grep -cm1 "${VER//./}")" == 1 ]];then
echo "! Là phiên bản mới nhất."
gh run cancel $GITHUB_RUN_ID
sleep 10
exit 0
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

if [ -e apk/YouTube1 ];then
if [ "$(unzip -l apk/YouTube1 | grep -cm1 'base.apk')" == 1 ];then
echo "- apk1 thành apks."
mv apk/YouTube1 apk/YouTube.apks
else
echo "- apk1 thành apk."
mv apk/YouTube1 apk/YouTube.apk
fi
fi

if [ -e apk/YouTube2 ];then
if [ "$(unzip -l apk/YouTube2 | grep -cm1 'base.apk')" == 1 ];then
echo "- apk2 thành apks."
mv apk/YouTube2 apk/YouTube.apks
else
echo "- apk2 thành apk."
mv apk/YouTube2 apk/YouTube.apk
fi
fi

if [ "$TYPE" == 'true' ];then
#lib='lib/*/*'
if [ -e apk/YouTube.apks/kkkkkk ];then
echo "- Giải nén base.apk"
unzip -qo apk/YouTube.apks 'base.apk' -d Tav
#unzip -qo apk/YouTube.apk lib/$DEVICE/* -d Tav
#mv -f Tav/lib/$DEVICE Tav/lib/$ach
else
echo "- Giải nén Lib"
cp apk/YouTube.apk Tav/base.apk
#unzip -qo apk/YouTube.apk lib/$DEVICE/* -d Tav
#mv -f Tav/lib/$DEVICE Tav/lib/$ach
fi
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
echo
eval "java -Djava.io.tmpdir=$HOME -jar $lib1 patch -p $lib2 apk/YouTube.apk -o YT.apk "$Mro $theme $Tof $Ton $feature""
echo '- Quá trình xây dựng apk xong.'

ls YT-temporary-files/*.apk
cp -rf YT-temporary-files/*.apk YT.apk

# Chờ xây dựng xong
if [ "$TYPE" == 'true' ];then
rsign Tav/base.apk YT.apk $HOME/Tav/YouTube.apk
cp -rf $HOME/Tav/YouTube.apk $HOME/Up/ZT-$VER-$ach${amoled2}-rsign.apk
else
apksign YT.apk $HOME/Up/YT-$VER-$ach${amoled2}.apk
ls Up
exit 0
fi
cd Tav
tar -cf - * | xz -9kz > $HOME/.github/Modun/common/lib.tar.xz
cd $HOME

# Tạo module.prop
echo 'id=YouTube
name=YouTube '$Kad'
author=kakathic
description=Build '$(date)', YouTube edited tool by Revanced mod added disable play store updates.
version='$VER'
versionCode='${VER//./}'
updateJson=https://github.com/'$GITHUB_REPOSITORY'/releases/download/Up/Up-K'$V$ach$amoled2'.json
' > $HOME/.github/Modun/module.prop

# Tạo json
echo '{
"version": "'$VER'",
"versionCode": "'${VER//./}'",
"zipUrl": "https://github.com/'$GITHUB_REPOSITORY'/releases/download/K'$V$VER'/YT-Hybrid-'$VER'-'$ach$amoled2'.Zip",
"changelog": "https://github.com/'$GITHUB_REPOSITORY'/releases/download/Up/Up-K'$V'notes.json"
}' > Up-K$V$ach$amoled2.json

echo -e 'Update '$(date)' \nYouTube: '$VER' \nVersion: '${VER//./}' \nAuto by kakathic' > Up-K${V}notes.json

Upenv BODY "Update $(date), YouTube: $VER, Version: ${VER//./}, Auto by kakathic"

# Tạo module magisk
cd $HOME/.github/Modun
zip -qr $HOME/Up/YT-Hybrid-$VER-$ach$amoled2.zip *
cd $HOME
ls Up
