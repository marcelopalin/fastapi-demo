#
# SEAMLESSLY MANAGE PYTHON VIRTUAL ENVIRONMENT WITH A MAKEFILE
#
# https://github.com/sio/Makefile.venv             v2020.05.07
#
#
# Insert `include Makefile.venv` at the bottom of your Makefile to enable these
# rules.
#
# When writing your Makefile use '$(VENV)/python' to refer to the Python
# interpreter within virtual environment and '$(VENV)/executablename' for any
# other executable in venv.
#
# This Makefile provides the following targets:
#   venv
#       Use this as a dependency for any target that requires virtual
#       environment to be created and configured
#   python, ipython
#       Use these to launch interactive Python shell within virtual environment
#   shell, bash, zsh
#   	Launch interactive command line shell. "shell" target launches the
#   	default shell Makefile executes its rules in (usually /bin/sh).
#   	"bash" and "zsh" can be used to refer to the specific desired shell.
#   show-venv
#       Show versions of Python and pip, and the path to the virtual environment
#   clean-venv
#       Remove virtual environment
#   $(VENV)/executable_name
#   	Install `executable_name` with pip. Only packages with names matching
#   	the name of the corresponding executable are supported.
#   	Use this as a lightweight mechanism for development dependencies
#   	tracking. E.g. for one-off tools that are not required in every
#   	developer's environment, therefore are not included into
#   	requirements.txt or setup.py.
#   	Note:
#   		Rules using such target or dependency MUST be defined below
#   		`include` directive to make use of correct $(VENV) value.
#   	Example:
#   		codestyle: $(VENV)/pyflakes
#   			$(VENV)/pyflakes .
#   	See `ipython` target below for another example.
#
# This Makefile can be configured via following variables:
#   PY
#       Command name for system Python interpreter. It is used only initialy to
#       create the virtual environment
#       Default: python3
#   REQUIREMENTS_TXT
#       Space separated list of paths to requirements.txt files.
#       Paths are resolved relative to current working directory.
#       Default: requirements.txt
#   WORKDIR
#       Parent directory for the virtual environment.
#       Default: current working directory.
#   VENVDIR
#   	Python virtual environment directory.
#   	Default: $(WORKDIR)/.venv
#
# This Makefile was written for GNU Make and may not work with other make
# implementations.
#
#
# Copyright (c) 2019-2020 Vitaly Potyarkin
#
# Licensed under the Apache License, Version 2.0
#    <http://www.apache.org/licenses/LICENSE-2.0>
#

SHELL := /usr/bin/env bash
PY?=python3
WORKDIR?=.
VENVDIR?=$(WORKDIR)/.venv
REQUIREMENTS_TXT?=requirements.txt  # Multiple paths are supported (space separated)
MARKER=.inicializado-pelo-Makefile.venv
PROJECTNAME := $(shell basename $(CURDIR))
DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

#
# HELP
#

define HELP
Manage projetc $(PROJECTNAME). Usage:

make help			- Show this help commands.
make install			- Change your prompt command, activate virtualenv and \
					  install requirements packages.
make clean			- Remove cached files and lock files.
make clean-venv			- Remove cached files and lock files and virtual environment.
make update			- Update pip dependencies pip freeze > requirements.txt.
make show-venv			- Show information about virtual environment.
make debug-venv			- Remove cached files and lock files and virtual environment.
make docker-info		- Show information about Docker and Docker Compose installed.
endef
export HELP

all help:
	@echo "$$HELP"

#
# Internal variable resolution
#

VENV=$(VENVDIR)/bin
EXE=
# Detect windows
ifeq (win32,$(shell $(PY) -c "import __future__, sys; print(sys.platform)"))
VENV=$(VENVDIR)/Scripts
EXE=.exe
endif


#
# Virtual environment
# make venv activate and install
#

.PHONY: venv
venv: $(VENV)/$(MARKER)


.PHONY: clean
clean:
	find . -name '*.pyc' -delete
	find . -name '__pycache__' -delete
	rm -rf ./logs
	find . -type f -wholename './logs/*.log' -delete

.PHONY: clean-venv
clean-venv:
	-$(RM) -r "$(VENVDIR)"

.PHONY: show-venv
show-venv: venv
	@$(VENV)/python -c "import sys; print('Python ' + sys.version.replace('\n',''))"
	@$(VENV)/pip --version
	@echo venv: $(VENVDIR)

.PHONY: debug-venv
debug-venv:
	@$(MAKE) --version
	$(info PY="$(PY)")
	$(info REQUIREMENTS_TXT="$(REQUIREMENTS_TXT)")
	$(info VENVDIR="$(VENVDIR)")
	$(info WORKDIR="$(WORKDIR)")


#
# Dependencies
# Ref: https://github.com/mnot/redbot/blob/main/Makefile.venv
#

_REQUIREMENTS=$(strip $(foreach path, $(REQUIREMENTS_TXT), $(wildcard $(path))))
ifneq ($(_REQUIREMENTS),)
VENVDEPENDS+=$(_REQUIREMENTS)
endif


$(VENV):
	$(PY) -m venv $(VENVDIR)
	$(VENV)/python -m pip install --upgrade pip setuptools

$(VENV)/$(MARKER): $(VENVDEPENDS) | $(VENV)
ifneq ($(_REQUIREMENTS),)
	$(VENV)/pip install $(foreach path,$(_REQUIREMENTS),-r $(path))
endif


#
# Interactive shells
# Ref: https://github.com/mnot/redbot/blob/main/Makefile.venv
#

.PHONY: python
python: venv
	exec $(VENV)/python

.PHONY: ipython
ipython: $(VENV)/ipython
	exec $(VENV)/ipython

.PHONY: update
update: venv # active venv
	$(VENV)/pip freeze > requirements.txt


.PHONY: install
install: venv
	@echo '. ~/.bash_prompt' >> ~/.bashrc
	cp .bash_prompt ~/
	. $(VENV)/activate && exec $(notdir $(SHELL))
	pre-commit install
	pre-commit autoupdate

#
# Commandline tools (wildcard rule, executable name must match package name)
#

ifneq ($(EXE),)
$(VENV)/%: $(VENV)/%$(EXE) ;
.PHONY:    $(VENV)/%
.PRECIOUS: $(VENV)/%$(EXE)
endif

$(VENV)/%$(EXE): $(VENV)/$(MARKER)
	$(VENV)/pip install --upgrade $*
	touch $@
