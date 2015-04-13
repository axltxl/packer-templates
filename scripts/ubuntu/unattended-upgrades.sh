APT_DIR=/etc/apt/apt.conf.d/

apt-get install -y unattended-upgrades

chown root:root /tmp/20auto-upgrades /tmp/50unattended-upgrades
chmod 644 /tmp/20auto-upgrades /tmp/50unattended-upgrades

mv /tmp/20auto-upgrades ${APT_DIR}
mv /tmp/50unattended-upgrades ${APT_DIR}
