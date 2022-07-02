set -eu

if [ -v "${CERT_BASE64}" ]; then
    echo "CERT_BASE64が未定義です"
    exit 1
fi
if [ -v "${CERT_PASSWORD}" ]; then
    echo "CERT_PASSWORDが未定義です"
    exit 1
fi

# 証明書
CERT_PATH=cert.pfx
echo -n $CERT_BASE64 | base64 -d - > $CERT_PATH

# 指定ファイルに署名する
function codesign() {
    TARGET="$1"
    SIGNTOOL=$(find "C:/Program Files (x86)/Windows Kits/10/App Certification Kit" -name "signtool.exe" | sort -V | tail -n 1)
    powershell "& '$SIGNTOOL' sign /fd SHA256 /td SHA256 /tr http://timestamp.digicert.com /f $CERT_PATH /p $CERT_PASSWORD '$TARGET'"
}

# 指定ファイルが署名されているか
function is_signed() {
    TARGET="$1"
    SIGNTOOL=$(find "C:/Program Files (x86)/Windows Kits/10/App Certification Kit" -name "signtool.exe" | sort -V | tail -n 1)
    powershell "& '$SIGNTOOL' verify /pa '$TARGET'" || return 1
}

is_signed python38.dll || codesign python38.dll
is_signed run.exe || codesign run.exe

is_signed python38.dll
is_signed run.exe

# 証明書を消去
rm $CERT_PATH
