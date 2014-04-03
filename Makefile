default: bundle/vundle

all: command-t

.git:
	git clone git://fridge.pov.lt/home/menesis/.vim

install bundle/command-t: bundle/vundle
	vim +BundleInstall

update: bundle/vundle
	vim +BundleInstall!

bundle/vundle:
	git clone https://github.com/gmarik/vundle.git bundle/vundle

command-t: bundle/command-t/ruby/command-t/ext.so
bundle/command-t/ruby/command-t/ext.so: bundle/command-t/ruby/command-t/extconf.rb
	@make -s bundle/command-t
	# You may need to apt-get install ruby ruby-dev if this fails:
	cd bundle/command-t/ruby/command-t/ && ruby extconf.rb && make
