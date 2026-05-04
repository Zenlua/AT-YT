# kakathic

# Home
HOME="$GITHUB_WORKSPACE"
date="$(TZ=Asia/Ho_Chi_Minh date +"%Y-%m-%d %H:%M:%S.%3N GMT%Z")"
cd $HOME

echo "$date"
echo

# Tạo thư mục
mkdir -p apk lib tmp jar Tav Up rmp
User="User-Agent: Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Mobile Safari/537.36"

# Tính năng 
feature="$FEATURE"

# khu vực fusion 
Taive(){ curl -sL -H "$User" --connect-timeout 50 "$1" -o "$2"; }
Xem(){ curl -sLG -H "$User" --connect-timeout 50 "$1"; }
XHex(){ xxd -p "$@" | tr -d "\n" | tr -d ' '; }
ZHex(){ xxd -r -p "$@"; }
apksign(){ java -jar $HOME/.github/Tools/apksigner.jar sign --cert "$HOME/.github/Tools/testkey.x509.pem" --key "$HOME/.github/Tools/testkey.pk8" --out "$2" "$1"; }
Upenv(){ echo "$1=${2//$'\n'/'%0A'}" >> $GITHUB_ENV; }
checkfile(){ [ -e "$1" ] && echo "FILE:  OK ${1##*/}" || ( echo "- Lỗi không không thấy file ${1##*/}"; exit 1; ); }
checkzip(){ [ "$(file $1 | grep -cm1 'Zip')" == 1 ] && echo "FILE:  OK ${1##*/}" || ( echo "- Lỗi file ${1##*/}"; exit 1; ); }
apkeditor(){ java -jar $HOME/.github/Tools/APKEditor-1.4.3.jar "$@"; }

Upout(){
r=$(cat $1)
r="${r//'%'/'%25'}"
r="${r//$'\n'/'%0A'}"
r="${r//$'\r'/'%0D'}"
echo "BODY=$r" >> $GITHUB_ENV
}

rsign(){
apkeditor d -t sig -i "$1" -sig "tmp/signatures_dir" &>/dev/null
apkeditor b -t sig -i "$2" -sig "tmp/signatures_dir" -o "$3" &>/dev/null; }

TaiYT(){
urrl="https://www.apkmirror.com"
uak1="$urrl$(wget -q -U "Mozilla/5.0 (Linux; Android 14; Mobile)" "$urrl/apk/$2" -O - | grep -m1 'downloadButton' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
uak2="$urrl$(wget -q -U "Mozilla/5.0 (Linux; Android 14; Mobile)" "$uak1" -O - | grep -m1 '>here<' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2 | sed 's|amp;||')"
wget -q -U "Mozilla/5.0 (Linux; Android 14; Mobile)" "$uak2" -O "apk/$1"
echo "Link: $uak2"
file "apk/$1" | tee "apk/$1.txt"; }

Taicli(){
uggrl="$(curl -sLG https://api.github.com/repos/$1/releases/latest | jq -r .assets[0].browser_download_url)"
Taive "$uggrl" "$2"
curl -sLG https://api.github.com/repos/$1/releases/latest | jq -r .assets[0].digest | cut -d: -f2 > ${2}.sum
echo "Url: $uggrl"
file "$2"; }

upload_gh(){
if [ "$(gh release verify "$1" 2>&1 | grep -o "$1")" == "$1" ];then
echo "Đã có tag: $1"
gh release edit "$1" --latest -t "$3" -n "$4"
gh release upload "$1" "$2" --clobber
else
echo "Đã tạo tag: $1"
gh release create "$1" "$2" -t "$3" -n "$4" || gh release upload "$1" "$2" --clobber
fi; }

upload_gh2(){
if [ "$(gh release verify "$1" 2>&1 | grep -o "$1")" == "$1" ];then
echo "Đã có tag: $1"
gh release edit "$1" --prerelease -t "$3" -n "$4"
gh release upload "$1" "$2" --clobber
else
echo "Đã tạo tag: $1"
gh release create "$1" "$2" -t "$3" -n "$4" || gh release upload "$1" "$2" --clobber
fi; }

# Tải cli
Taicli "$GITPCLI" "cli.jar"
Taicli "$GITPATCH" "patch.jar"

# Tùy chọn 
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

if [ -z $Keytem ]; then
kmss='-p'
sskkm='-b'
fi

echo
echo "- Kiểm tra bản YouTube mới nhất..."
Vidon="$(java -Djava.io.tmpdir=$HOME -jar cli.jar list-versions --patches patch.jar -f com.google.android.youtube | grep -w '(.*.)' | sort -n | tail -1 | awk '{print $1}')";
echo "  $Vidon"
echo

[ "$VERSION" == 'Auto' ] && VER="$Vidon" || VER="$VERSION"
V="${GITPCLI%/*}"
Kad=$(date "+%Y%m%d")

sum="$(cat patch.jar.sum 2>/dev/null)"
echo "Sum: $sum"

if [ "$VERSION" == 'Auto' ] && [ "$(Xem https://github.com/$GITHUB_REPOSITORY/releases/download/Up/K${V}notes.json | grep -cm1 "$sum")" == 1 ];then
echo "! Là phiên bản mới nhất."
sleep 5
gh run cancel $GITHUB_RUN_ID
sleep 5
exit 1
fi

# Tải Youtube
apk1="google-inc/youtube/youtube-${VER//./-}-release/youtube-${VER//./-}-2-android-apk-download"
apk2="google-inc/youtube/youtube-${VER//./-}-release/youtube-${VER//./-}-android-apk-download"
apk3="google-inc/youtube/youtube-${VER//./-}-release/youtube-${VER//./-}-3-android-apk-download"
apk4="google-inc/youtube/youtube-${VER//./-}-release/youtube-${VER//./-}-4-android-apk-download"
TaiYT 'YouTube1.zip' "$apk1" &
TaiYT 'YouTube2.zip' "$apk2" &
TaiYT 'YouTube3.zip' "$apk3" &
TaiYT 'YouTube4.zip' "$apk4"
wait

for vv in 1 2 3 4; do
if [ -e apk/YouTube$vv.zip ];then
    if [ "$(unzip -l apk/YouTube$vv.zip 2>/dev/null | grep -cm1 'base.apk')" == 1 ];then
    echo "- Apk $vv thành apks"
    mv apk/YouTube$vv.zip apk/YouTube.apks
    elif [ "$(unzip -l apk/YouTube$vv.zip 2>/dev/null | grep -cm1 'AndroidManifest.xml')" == 1 ];then
    echo "- Apk $vv thành apk"
    mv apk/YouTube$vv.zip apk/YouTube.apk
    else
    echo "- Không phải là zip YouTube$vv"
    fi
fi
done

# check apk list
ls apk/*
[ -f apk/YouTube.apk ] || { echo "Không thấy YT apk"; exit 1; }
[ -f apk/YouTube.apks ] || { echo "Không thấy YT apks"; exit 1; }

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
zip -qr apk/YouTube.apk -d $lib

# Xử lý revanced patches
if [ "$Vidon" != "$VER" ] && [ "$Vidon" ];then
echo "- Chuyển đổi phiên bản $VER"
unzip -qo "patch.jar" -d $HOME/jar
for vak in $(grep -Rl "$Vidon" $HOME/jar); do
cp -rf $vak test
XHex test | sed -e "s/$(echo -n "$Vidon" | XHex)/$(echo -n "$VERSION" | XHex)/" | ZHex > $vak
done
cd $HOME/jar
rm -fr patch.jar
zip -qr "$HOME/$lib2" *
cd $HOME
fi

# MOD YouTube 
echo "▼ Bắt đầu quá trình xây dựng..."
echo

eval "java -Djava.io.tmpdir=$HOME -jar cli.jar patch -p patch.jar $sskkm apk/YouTube.apk -o YT.apk "$Mro $theme $Tof $Ton $feature""
echo

echo '- Quá trình xây dựng apk xong.'
echo

ls morphe-temporary-files/*.apk
cp -rf morphe-temporary-files/*.apk YT2.apk

# Chờ xây dựng xong
if [ "$TYPE" == 'true' ];then
echo "Tạo rsign..."
echo
mv YT.apk $HOME/Tav/YouTube.apk
cd tmp
zip -qr $HOME/YT2.apk *
cd $HOME
rsign Tav/base.apk YT2.apk $HOME/Up/ZT-$VER-$ach${amoled2}-rsign.apk
else
apksign YT.apk $HOME/Up/YT-$VER-$ach${amoled2}.apk
find Up/* -type f
Upenv FILE "$(find Up/* -type f)"
for vv in $(find Up/* -type f); do
upload_gh "K-$V-$VER-$Kad" "$vv" "YT-RE $VER ${V^}" \
"YT-RE"
done
exit 0
fi

cd Tav
tar -cf - * | xz -9kz > $HOME/.github/Modun/common/lib.tar.xz
cd $HOME

# Tạo module.prop
echo 'id=YouTube
name=YouTube '${V^}'
author=kakathic
description=Build '$date', YouTube edited tool by Revanced mod added disable play store updates.
version='$VER'
versionCode='${VER//./}'
updateJson=https://github.com/'$GITHUB_REPOSITORY'/releases/download/Up/K'$V$ach$amoled2'.json
' > $HOME/.github/Modun/module.prop

# Tạo json
echo '{
"version": "'$VER'",
"versionCode": "'${VER//./}'",
"zipUrl": "https://github.com/'$GITHUB_REPOSITORY'/releases/download/'"K-$V-$VER-$Kad"'/YT-Hybrid-'$VER'-'$ach$amoled2'.Zip",
"changelog": "https://github.com/'$GITHUB_REPOSITORY'/releases/download/Up/K'${V}'notes.json"
}' > K$V$ach$amoled2.json

echo -e 'Update '$date' \nYouTube: '$VER' \nVersion: '${VER//./}' \nAuto by kakathic \nSum: '$sum'' > K${V}notes.json
body="**Note: Auto by kakathic**

+ Update $date
+ YouTube: $VER
+ Changelog: [See more](https://github.com/$GITPATCH/releases/latest)

+ ![GitHub Downloads (all assets, specific tag)](https://img.shields.io/github/downloads/$GITHUB_REPOSITORY/K-$V-$VER-$Kad/total?label=Download&color=%230072F4)"

# Tạo module magisk
cd $HOME/.github/Modun
zip -qr $HOME/Up/YT-Hybrid-$VER-$ach$amoled2.zip *
cd $HOME

echo "Upload apk, zip"
for vv in $(find Up/* -type f); do
echo "Upload: $vv"
upload_gh "K-$V-$VER-$Kad" "$vv" "YT-RE $VER ${V^}" "$body"
done

echo "Upload json, notes"
for vn in $(find K*.json -type f); do
echo "Upload: $vn"
upload_gh2 "Up" "$vn" "Update" "YT-RE"
done

if [ "$UPTG" == "true" ];then

echo "Telegram"
chat_tg="New version of the patch tool

• Link: <a href=\"https://github.com/Zenlua/AT-YT/releases/tag/K-$V-$VER-$Kad\">Download</a>
• Mod by: ${V^}
• Youtube version: $VER
• <a href=\"https://github.com/$GITPATCH/releases/latest\">Changelog</a>

#youtube #bot_auto"

# tool_tree
curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN_TOOLTREE/sendMessage" \
-d chat_id="$TG_ID_TOOLTREE" \
-d parse_mode="HTML" \
--data-urlencode text="$chat_tg"

# k20vn
curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN_TOOLTREE/sendMessage" \
-d chat_id="$TG_ID_K20PVN" \
-d parse_mode="HTML" \
--data-urlencode text="$chat_tg"
fi


