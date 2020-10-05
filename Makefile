dep:
	cpanm --installdeps .

check:
	perlcritic --profile .perlcriticrc --theme perl7
