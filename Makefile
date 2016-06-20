all: bundle/vundle

install bundle/command-t: bundle/vundle
	vim +BundleInstall

update: bundle/vundle
	vim +BundleInstall!

bundle/vundle:
	git clone https://github.com/gmarik/vundle.git bundle/vundle

command-t: bundle/command-t/ruby/command-t/ext.so
bundle/command-t/ruby/command-t/ext.so:
	@make -s bundle/command-t
	# You may need to apt-get install ruby ruby-dev if this fails:
	cd bundle/command-t/ruby/command-t/ && ruby extconf.rb && make
