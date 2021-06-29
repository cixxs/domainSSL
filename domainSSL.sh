#!/bin/sh

read -p "请输入域名:" domain && cd /tmp
if [ ! -f "lego_v3.8.0_linux_arm64.tar.gz" ]; then
  wget https://github.com/go-acme/lego/releases/download/v3.8.0/lego_v3.8.0_linux_arm64.tar.gz
fi
tar zxvf lego_v3.8.0_linux_arm64.tar.gz
chmod 755 *
service nginx stop
./lego --email="admin@$domain" --domains="$domain" --http -a run
service nginx start
if ls ./.lego/certificates | grep "$domain"
    then
    mkdir -p /home/ssl/$domain
    cp ./.lego/certificates/$domain.crt /home/ssl/$domain/1.pem
    cp ./.lego/certificates/$domain.key /home/ssl/$domain/1.key
    path="/home/ssl/$domain/"
    echo '证书签发成功，证书文件保存在'$path'。'
else
    echo '证书签发失败，请检查80端口是否被占用，域名解析或者输入域名是否正确。'
fi
