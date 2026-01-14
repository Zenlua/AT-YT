# kakathic

# Home
HOME="$GITHUB_WORKSPACE"
date="$(TZ=Asia/Ho_Chi_Minh date +"%Y-%m-%d %H:%M:%S.%3N GMT%Z")"

# Tạo thư mục
mkdir -p apk lib tmp jar Tav Up rmp
User="User-Agent: Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Mobile Safari/537.36"

# Tính năng 
feature="$FEATURE"

# khu vực fusion 
Taive () { curl -s -L -N -k -H "$User" --connect-timeout 20 "$1" -o "$2"; }
Xem () { curl -s -G -L -N -k -H "$User" --connect-timeout 20 "$1"; }
XHex(){ xxd -p "$@" | tr -d "\n" | tr -d ' '; }
ZHex(){ xxd -r -p "$@"; }
apksign () { java -jar $HOME/.github/Tools/apksigner.jar sign --cert "$HOME/.github/Tools/testkey.x509.pem" --key "$HOME/.github/Tools/testkey.pk8" --out "$2" "$1"; }
Upenv(){ echo "$1=$2" >> $GITHUB_ENV; }
checkfile(){ [ -e "$1" ] && echo "FILE:  OK ${1##*/}" || ( echo "- Lỗi không không thấy file ${1##*/}"; exit 1; ); }
checkzip(){ [ "$(file $1 | grep -cm1 'Zip')" == 1 ] && echo "FILE:  OK ${1##*/}" || ( echo "- Lỗi file ${1##*/}"; exit 1; ); }
apkeditor () { java -jar $HOME/.github/Tools/APKEditor-1.4.3.jar "$@"; }

rsign(){
apkeditor d -t sig -i "$1" -sig "tmp/signatures_dir" &>/dev/null
apkeditor b -t sig -i "$2" -sig "tmp/signatures_dir" -o "$3" &>/dev/null; }

TaiYT(){
urrl="https://www.apkmirror.com"
uak1="$urrl$(Xem "$urrl/apk/$2" | grep -m1 'downloadButton' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
uak2="$urrl$(Xem "$uak1" | grep -m1 '>here<' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2 | sed 's|amp;||')"
Taive "$uak2" "apk/$1"
echo "Link: $uak2"
file "apk/$1" | tee "apk/$1.txt"; }

Taicli(){
uggrl="$(curl -sLG https://api.github.com/repos/$1/releases/latest | jq -r .assets[0].browser_download_url)"
Taive "$uggrl" "$2"
echo "Url: $uggrl"; }

# Tải cli
Taicli "$GITPCLI" "cli.jar"
Taicli "$GITPATCH" "patch.jar"

# Tải Youtube
apk1="google-inc/youtube/youtube-${VER//./-}-release/youtube-${VER//./-}-2-android-apk-download"
apk2="google-inc/youtube/youtube-${VER//./-}-release/youtube-${VER//./-}-android-apk-download"
TaiYT 'YouTube1' "$apk1" & TaiYT 'YouTube2' "$apk2"









