#!/bin/bash
# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

apt-get update
cd /tmp
export DEBIAN_FRONTEND=noninteractive
apt-get -yq install mingw-w64

sleep 3
 MSF nightly framework installer
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
chmod +x msfinstall
./msfinstall

 sliver install:
curl https://sliver.sh/install -o sliverc2.sh
chmod +x sliverc2.sh
./sliverc2.sh
rm /tmp/msfinstall
rm /tmp/sliverc2-bootstrap.sh
rm /tmp/sliverc2.sh
rm /tmp/terraf*.sh
systemctl status sliver --no-pager
exit
