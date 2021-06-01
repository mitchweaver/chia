PREFIX = ${HOME}/.local

all:
	install -Dm0755 bin/chia-logview.sh ${PREFIX}/bin/chia-logview.sh

test:
	shellcheck -s sh bin/* installers/*
