.ONESHELL:# single shell invocation for all lines in the recipe

.DEFAULT_GOAL = help

### VARIABLES ###
#
export PATH 	:=$(CURDIR)/scripts:$(PATH)

### TARGETS ###
#

binary: clean ## Build the binary distribution
	@mvn package -P assemblies -Dgpg.skip=true

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean: 	## Clean all build artefacts
	@mvn clean

compile: ## Compile the source code
	@mvn compile

jar: clean ## Build the JAR file
	@mvn package

run: compile ## Run PerfTest, pass exec arguments via ARGS, e.g. ARGS="-x 1 -y 1 -r 1"
	@mvn exec:java -Dexec.mainClass="com.rabbitmq.perf.PerfTest" -Dexec.args="$(ARGS)"

signed-binary: clean ## Build a GPG signed binary
	@mvn package -P assemblies

.PHONY: binary help clean compile jar run signed-binary
