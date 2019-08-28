#!/bin/sh 


apt install openssh-client

cat > /etc/systemd/system/ssh-socks.service <<- EOF
[Unit]
Description=ssh socks proxy
After=network-online.target syslog.target
Wants=

[Service]
Type=simple
User=chen
Group=chen
ExecStartPre=
ExecStart=/usr/bin/ssh -CN -D *:7070 chen@mtdcy.com -p 6015
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
Alias=
EOF

systemctl enable ssh-socks
systemctl stop ssh-socks
systemctl start ssh-socks
