PREFIX = ${HOME}/.local

all: 
	@echo "Use 'make install'."

install:
	install -Dm0755 bin/* ${PREFIX}/bin/

test:
	shellcheck -s sh bin/* installers/*
