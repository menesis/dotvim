all: bundle/vundle

install:
	vim +BundleInstall

bundle/vundle:
	git clone https://github.com/gmarik/vundle.git bundle/vundle

command-t bundle/command-t/ruby/command-t/ext.so: bundle/command-t/ruby/command-t/extconf.rb
	# You may need to apt-get install ruby ruby-dev if this fails:
	cd bundle/command-t/ruby/command-t/ && ruby extconf.rb && make
