#!/bin/bash

if ! grep -q '^# Rules needed by docker' /etc/ufw/before.rules; then
cat <<EOF > /tmp/before.rules
# Rules needed by docker (do not modify this line)
# See https://svenv.nl/unixandlinux/dockerufw
*nat
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING ! -o docker0 -s 172.17.0.0/16 -j MASQUERADE
COMMIT
EOF
cat /etc/ufw/before.rules >> /tmp/before.rules

cp /etc/ufw/before.rules /etc/ufw/before.rules.bak
cat /tmp/before.rules > /etc/ufw/before.rules
rm -f /tmp/before.rules
diff -u /etc/ufw/before.rules.bak /etc/ufw/before.rules
fi

