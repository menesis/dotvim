all: bundle/vundle

install: bundle/vundle
	vim +BundleInstall

update: bundle/vundle
	vim +BundleInstall!

bundle/vundle:
	git clone https://github.com/gmarik/vundle.git bundle/vundle
