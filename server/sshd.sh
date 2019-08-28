#!/bin/sh 

apt install openssh-server

cat > /etc/ssh/sshd_config <<- EOF
Protocol 2
LogLevel VERBOSE 	# INFO
StrictModes yes
PasswordAuthentication yes
PubkeyAuthentication yes
AcceptEnv LANG LC_*
UsePAM yes
UseDNS no
AddressFamily inet
SyslogFacility AUTHPRIV

X11Forwarding yes
X11DisplayOffset 10

PrintMotd yes
PrintLastLog yes

TCPKeepAlive yes
ClientAliveInterval 15
ClientAliveCountMax 4 		# 60s 

Subsystem sftp /usr/lib/openssh/sftp-server
EOF

cat > /etc/default/ssh <<- EOF
SSHD_OPTS=""
EOF

systemctl restart sshd
