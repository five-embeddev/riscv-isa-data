#!/bin/env ruby

require 'liquid'
require 'yaml'


TEMPLATE="template.html"
YAML_DATA="../../opcodes.yaml"
RESULT="result.html"


File.open(YAML_DATA,"r") { | fin |
  yaml_text = fin.read()
  yaml_data = YAML.load(yaml_text) 
  File.open(TEMPLATE,"r") { | fin |
    template_data = fin.read()
    template = Liquid::Template.parse(template_data)
    output = template.render(
      { 'data' => yaml_data }, { strict_variables: true })
    File.open(RESULT, "w") {|fout|
      fout.write(output)
    }
  }
}

