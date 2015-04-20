date > /etc/vagrant_box_build_time

#
# Install vagrant insecure SSH key
#
mkdir -pm 700 /home/vagrant/.ssh
curl -L https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

#
#sudoers configuration requires tty
#
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers