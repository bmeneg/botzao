ifeq ($(PHASE_DEVELOP), 1)
	ENABLE_DEVELOP = --with-develop
endif
ifeq ($(PHASE_TEST), 1)
	ENABLE_DEVELOP = --with-test
endif

deps:
	cpanm $(ENABLE_DEVELOP) $(ENABLE_TEST) --installdeps .

check:
	@prove -l t/

help:
	@echo "cbot project makefile"
	@echo "Usage:"
	@echo "    make <options> <target>"
	@echo ""
	@echo "Targets:"
	@echo "    deps 	Install dependencies"
	@echo "    check	Run tests in t/ against the code"
	@echo ""
	@echo "Options:"
	@echo "(available only for \"deps\" target)"
	@echo "  Phase:"
	@echo "    PHASE_DEVELOP=1	Install packages required for development phase"
	@echo "    PHASE_TEST=1		Install packages required for test phase"
	@echo ""
	@echo "Example:"
	@echo "    make PHASE_DEVELOP=1 deps"
