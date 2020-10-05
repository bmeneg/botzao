ifeq ($(WITH_SQLITE), 1)
	ENABLE_SQLITE = --with-feature=sqlite
endif

ifeq ($(PHASE_DEVELOP), 1)
	ENABLE_DEVELOP = --with-develop
endif

deps:
	cpanm $(ENABLE_DEVELOP) $(ENABLE_SQLITE) --installdeps .

check:
	perlcritic --profile .perlcriticrc --theme perl7 .

help:
	@echo "tbott project makefile"
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
	@echo "  Features:"
	@echo "    WITH_SQLITE=1	Enable storage with sqlite"
	@echo ""
	@echo "Example:"
	@echo "    make PHASE_DEVELOP=1 WITH_SQLITE=1 deps"
