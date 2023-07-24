#!/bin/env ruby

require 'yaml'
require 'optparse'

options = {
  :csr_yaml_in=>"../../csr.yaml",
  :csr_yaml_out=>"../../csr.yaml",
}

OptionParser.new do |opt|
  opt.on('--csr-yaml-in CSR_YAML') { |o| options[:csr_yaml_in] = o }
  opt.on('--csr-yaml-out CSR_YAML') { |o| options[:csr_yaml_out] = o }
end.parse!

if File.exists?(options[:csr_yaml_in])  then
   csr_data = YAML.load_file(options[:csr_yaml_in])
else
  exit(1)
end

csr_data["regs"] = csr_data["regs"].sort_by {|key| key}.to_h

File.open(options[:csr_yaml_out],"w") do | fout |
  fout.write(csr_data.to_yaml)
end
