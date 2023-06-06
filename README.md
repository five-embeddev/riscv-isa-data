# RISC-V ISA Data

Machine readable ISA data.

Descriptions are in YAML.

Used for https://five-embeddev.com/ quick references pages.

Used for code generation.


## Tests

Install `yamllint` and `yamlfix`.

e.g.

~~~
pip install yamlfix
sudo apt install yamllint
~~~

Run tests.

~~~
make test
~~~

## Examples

Generate a table of opcode data using Ruby.

~~~
cd examples/ruby
gem install liquid
./test.rb
~~~

This will create a file `result.html` from the template `template.html` using the data in `opcodes.yaml`.



