#!/bin/sh -ex

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# system requirements
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
sudo yum update -y

sudo yum install -y \
    gcc openssl-devel bzip2-devel zlib-devel libffi \
    libffi-devel libsqlite3x-devel python3-devel gmp-devel  \
    boost-devel libsodium-devel wget nodejs npm

sudo yum groupinstall -y "Development Tools"

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# build
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
cd /tmp
git clone https://github.com/Chia-Network/chia-blockchain.git
cd chia-blockchain

sed -i 's/.*redhat.*/fedora/' install.sh
sed -i 's/.*redhat.*/fedora/' install-gui.sh

sh install.sh

# shellcheck disable=1091
. ./activate

sh install-gui.sh

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# install
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
if [ -d /opt/chia-blockchain ] ; then
    sudo rm -rf /opt/chia-blockchain
fi
cd /tmp
sudo mv chia-blockchain /opt/

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# helper files
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# wrapper
cat >"${HOME}/.local/bin/chia-blockchain" <<EOF
#!/bin/sh -ex
cd /opt/chia-blockchain
. ./activate
cd chia-blockchain-gui
PYTHONPATH=..:.:$PYTHONPATH \
npm run electron
EOF
chmod +x "${HOME}/.local/bin/chia-blockchain"

# desktop entry
cat >"${HOME}/.local/applications/chia-blockchain.desktop" <<EOF
[Desktop Entry]
Name=chia-blockchain
Comment=chia-blockchain
Keywords=chia;blockchain

TryExec=chia-blockchain
Exec=chia-blockchain
Icon=/opt/chia-blockchain/chia-blockchain-gui/src/assets/img/chia.png

Type=Application
StartupWMClass=chia-blockchain
StartupNotify=false
Terminal=false
X-GNOME-SingleWindow=false
EOF

echo
echo done!
