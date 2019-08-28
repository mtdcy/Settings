#!/bin/sh 

apt install samba

cat > /etc/samba/smb.conf <<- EOF
[Projects]
    comment = Projects on NUC8i7HNK
    path = /home/chen/Projects
    read only = no
    browsable = yes
    create mask = 0644
    directory mask = 0755
EOF

systemctl restart smbd

# add passwd
# sudo smbpasswd -a username
