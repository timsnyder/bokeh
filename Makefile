build:
	python setup.py develop --build_js

FF_PATHS= $(wildcard $$HOME/local/firefox-*/.)
FF_PATHS= $$HOME/local/firefox-31.0esr/firefox
# TODO loop over multiple firefoxen while testing

# Use out own make variable instead of pytest's env var so that the echo'd cmdline captures
# everything
ifdef LF
    PYTEST_ARGS+= --lf
endif

NPROC?=$(shell nproc)
SUBTESTS?= unit examples integration js
BROWSER?= google-chrome
GIT_DESC=$(shell git describe --dirty)
TESTLOG_DIR=test_logs
LOGNAME_MACRO=$(TESTLOG_DIR)/$(1)_test_results_$(GIT_DESC).html
export BOKEH_RESOURCES=inline

test:
	# run them serially because they don't take that long and the output will be much more sensible
	for t in $(SUBTESTS); do                 \
	    figlet $$t ;                         \
	    $(MAKE) --no-print-directory $$t;    \
	done

unit: | $(TESTLOG_DIR)
	 py.test --firefox-path=$(FF_PATHS) --html=$(call LOGNAME_MACRO,$@) -m "not ( js or examples or integration )" $(PYTEST_ARGS)

examples: | $(TESTLOG_DIR)
	 py.test --firefox-path=$(FF_PATHS) --examplereport=$(call LOGNAME_MACRO,$@) -m "examples" -n $(NPROC) $(PYTEST_ARGS)

integration: | $(TESTLOG_DIR)
	 #TODO use xvfb to keep selenium from spamming my actual X server
	 py.test --firefox-path=$(FF_PATHS) --html=$(call LOGNAME_MACRO,$@) -m "integration" $(PYTEST_ARGS) 

js: | $(TESTLOG_DIR)
	cd bokehjs && gulp test

doc:
	$(MAKE) -C sphinx clean all
	$(MAKE) -C sphinx serve

help:
	@echo "Tim Snyder's Makefile for Running Bokeh Unit Tests"
	@echo
	@echo "Provided Targets"
	@echo
	@echo "    build (default target) - build bokehjs and python in 'develop' mode"
	@echo "    test                   - run all test subset targets serially"
	@echo "    doc                    - build sphinx and then serve it"
	@echo
	@echo "  Test Subset Targets:"
	@echo "    unit        - python unit tests running py.test directly"
	@echo "    examples    - python examples using py.test directly"
	@echo "    integration - python integration tests using py.test directly"
	@echo "    js          - gulp test bokehjs"

$(TESTLOG_DIR):
	mkdir $@

.PHONY: build help test doc $(SUBTESTS)
