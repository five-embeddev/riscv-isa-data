YAML_PATH=../
YAML_FILES=${notdir $(wildcard ${YAML_PATH}*.yaml)}

all : ${YAML_FILES:%=%.lint}

%.lint :${YAML_PATH}%
	yamllint -c config.yaml $<

