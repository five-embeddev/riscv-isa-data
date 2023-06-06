YAML_PATH=./
YAML_FILES=${notdir $(wildcard ${YAML_PATH}*.yaml)}

fix : ${YAML_FILES:%=%.fix}

%.fix : %
	yamlfix $<

test : 
	${MAKE} -C test

.PHONY: test
