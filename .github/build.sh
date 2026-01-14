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
