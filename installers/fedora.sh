#!/bin/sh -ex

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# system requirements
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
sudo yum update -y

sudo yum groupinstall -y "Development Tools"

sudo yum install -y \
    gcc openssl-devel bzip2-devel zlib-devel libffi \
    libffi-devel libsqlite3x-devel python3-devel gmp-devel  \
    boost-devel libsodium-devel wget nodejs npm python-websockets

sudo yum install -y \
    python3-pip python3-setuptools \
    python3-click python3-yaml

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# build ---- NOTE: recently learned it MUST be built at the
#                  directory it will be installed at!
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
if [ -d /opt/chia-blockchain ] ; then
    sudo rm -rf /opt/chia-blockchain
fi
git clone https://github.com/Chia-Network/chia-blockchain -b latest /tmp/chia-blockchain
sudo mv -f /tmp/chia-blockchain /opt/
cd /opt/chia-blockchain

sed -i 's/.*redhat.*/fedora/' install.sh
sed -i 's/.*redhat.*/fedora/' install-gui.sh

sh install.sh

# shellcheck disable=1091
. ./activate

sudo python3 setup.py install

# =/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=

echo
printf 'install the gui? (y/n):'
read -r ans
case $ans in
    y)
        echo Installing...
        ;;
    *)
        echo Quitting.
        exit
esac
echo

sh install-gui.sh

cd chia-blockchain-gui
ln -sf ../chia chia
ln -sf ../mozilla-ca mozilla-ca

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# helper files for gui
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
mkdir -p "${HOME}/.local/bin" "${HOME}/.local/applications"

# wrapper
cat >"${HOME}/.local/bin/chia-blockchain" <<"EOF"
#!/bin/sh -ex
cd /opt/chia-blockchain
. ./activate
cd chia-blockchain-gui
PYTHONPATH=.:../venv/lib/python3.9/site-packages:$PYTHONPATH \
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
