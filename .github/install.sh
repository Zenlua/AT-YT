# kakathic

sudo rm -rf /usr/share/dotnet
sudo rm -rf /opt/ghc
sudo rm -rf /usr/local/share/boost

HOME="$GITHUB_WORKSPACE"
sudo apt install zipalign bash 2>/dev/null >/dev/null
cd $HOME

# Tạo thư mục
mkdir -p apk lib tmp jar Tav Up rmp
User="User-Agent: Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Mobile Safari/537.36"

# Tính năng 
feature="$FEATURE"

# khu vực fusion 
Taive () { curl -s -L -N -k --dns-servers "1.1.1.1,8.8.8.8,8.8.4.4" -H "$User" --connect-timeout 20 "$1" -o "$2"; }
Xem () { curl -s -G -L -N -k --dns-servers "1.1.1.1,8.8.8.8,8.8.4.4" -H "$User" --connect-timeout 20 "$1"; }
XHex(){ xxd -p "$@" | tr -d "\n" | tr -d ' '; }
ZHex(){ xxd -r -p "$@"; }
apksign () { java -jar $HOME/.github/Tools/apksigner.jar sign --cert "$HOME/.github/Tools/testkey.x509.pem" --key "$HOME/.github/Tools/testkey.pk8" --out "$2" "$1"; }
Upenv(){ echo "$1=$2" >> $GITHUB_ENV; }
checkfile(){ [ -e "$1" ] && echo "FILE:  OK ${1##*/}" || ( echo "- Lỗi không không thấy file ${1##*/}"; exit 1; ); }
checkzip(){ [ "$(file $1 | grep -cm1 'Zip')" == 1 ] && echo "FILE:  OK ${1##*/}" || ( echo "- Lỗi file ${1##*/}"; exit 1; ); }

Loading(){
while true; do
if [ -e "$1" ] && [ -e "$2" ];then
echo "FILE:  OK"
break
else
sleep 1
gfdgv=$(($gfdgv + 1))
if [ "$gfdgv" -ge 120 ];then
echo "- Quá thời gian cho phép, vì $1 $2...";
break
fi
fi
done; }

checklog(){
while true; do
if [ "$(grep -cm1 "$1" "$2")" == 1 ];then
echo "Đã tìm thấy:  $1"
break
else
sleep 1
gfdgv=$(($gfdgv + 1))
if [ "$gfdgv" -ge 100 ];then
echo "- Quá thời gian cho phép, sẽ tự bỏ qua...";
break
fi
fi
done; }
