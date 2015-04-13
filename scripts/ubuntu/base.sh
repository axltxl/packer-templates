# Upgrade all packages
apt-get update
apt-get -y upgrade

# sudoers configuration
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e 's/%sudo  ALL=(ALL:ALL) ALL/%sudo  ALL=NOPASSWD:ALL/g' /etc/sudoers

# sshd pre-configuration
echo "UseDNS no" >> /etc/ssh/sshd_config