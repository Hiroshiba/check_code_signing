# !!! コードサイニング証明書を取り扱うので取り扱い注意 !!!

set -eu

if [ ! -v CERT_BASE64 ]; then
    echo "CERT_BASE64が未定義です"
    exit 1
fi
if [ ! -v CERT_PASSWORD ]; then
    echo "CERT_PASSWORDが未定義です"
    exit 1
fi

if [ $# -ne 1 ]; then
    echo "引数の数が一致しません"
    exit 1
fi
target_file_glob="$1"

# eSignerCKAのセットアップ
INSTALL_DIR='C:\Users\runneradmin\eSignerCKA'
curl -LO "https://github.com/SSLcom/eSignerCKA/releases/download/v1.0.6/SSL.COM-eSigner-CKA_1.0.6.zip"
unzip -o SSL.COM-eSigner-CKA_1.0.6.zip
rm SSL.COM-eSigner-CKA_1.0.6.zip
mv *eSigner*CKA_*.exe eSigner_CKA_Installer.exe
powershell "& ./eSigner_CKA_Installer.exe /CURRENTUSER /SILENT /SUPPRESSMSGBOXES /DIR="$INSTALL_DIR""
rm eSigner_CKA_Installer.exe

# should to product
USERNAME="mortales@gmail.com"
PASSWORD="passowrd"
TOTP_SECRET="mI0KkB8...JW1oNgbUfQCwJU="
powershell "& '$INSTALL_DIR\eSignerCKATool.exe' config -mode sandbox -user '$USERNAME' -pass '$PASSWORD' -totp '$TOTP_SECRET' -key '$INSTALL_DIR\master.key' -r"

# # 指定ファイルに署名する
# function codesign() {
#     TARGET="$1"
#     SIGNTOOL=$(find "C:/Program Files (x86)/Windows Kits/10/App Certification Kit" -name "signtool.exe" | sort -V | tail -n 1)
#     powershell "& '$SIGNTOOL' sign /fd SHA256 /td SHA256 /tr http://timestamp.digicert.com /f $CERT_PATH /p $CERT_PASSWORD '$TARGET'"
# }

# # 指定ファイルが署名されているか
# function is_signed() {
#     TARGET="$1"
#     SIGNTOOL=$(find "C:/Program Files (x86)/Windows Kits/10/App Certification Kit" -name "signtool.exe" | sort -V | tail -n 1)
#     powershell "& '$SIGNTOOL' verify /pa '$TARGET'" || return 1
# }

# # 署名されていなければ署名
# ls $target_file_glob | while read target_file; do
#     if is_signed "$target_file"; then
#         echo "署名済み: $target_file"
#     else
#         echo "署名: $target_file"
#         codesign "$target_file"
#     fi
# done

# # 証明書を消去
# rm $CERT_PATH
