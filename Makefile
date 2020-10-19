ifeq ($(PHASE_DEVELOP), 1)
	ENABLE_DEVELOP = --with-develop
endif

deps:
	cpanm $(ENABLE_DEVELOP) --installdeps .

check:
	perlcritic --profile .perlcriticrc --theme perl7 .

help:
	@echo "cbot project makefile"
	@echo "Usage:"
	@echo "    make <options> <target>"
	@echo ""
	@echo "Targets:"
	@echo "    deps 	Install dependencies"
	@echo "    check	Run Perl::Critic against the code"
	@echo ""
	@echo "Options:"
	@echo "(available only for \"deps\" target)"
	@echo "  Phase:"
	@echo "    PHASE_DEVELOP=1	Install packages required for development phase"
	@echo ""
	@echo "Example:"
	@echo "    make PHASE_DEVELOP=1 deps"
