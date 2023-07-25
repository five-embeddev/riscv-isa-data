#!/bin/env ruby

require 'yaml'
require 'optparse'

options = {
  :opcodes_yaml_in=>"../../opcodes.yaml",
  :opcodes_yaml_out=>"../../opcodes.yaml",
}

OptionParser.new do |opt|
  opt.on('--opcodes-yaml-in OPCODES_YAML') { |o| options[:opcodes_yaml_in] = o }
  opt.on('--opcodes-yaml-out OPCODES_YAML') { |o| options[:opcodes_yaml_out] = o }
end.parse!

if File.exists?(options[:opcodes_yaml_in])  then
   opcodes_data = YAML.load_file(options[:opcodes_yaml_in])
else
  exit(1)
end

def sort_hash_list(data)
  data = data.sort_by {|key| key}.to_h
  data.keys.sort.each do | key | 
    data[key] = data[key].sort
  end
  return data
end
def sort_hash_hash_list(data)
  data = data.sort_by {|key| key}.to_h
  data.keys.sort.each do | key | 
    data[key] = sort_hash_list(data[key])
  end
  return data
end
def sort_hash(data)
  return data.sort_by {|key| key}.to_h
end
def sort_hash_hash(data)
  data = data.sort_by {|key| key}.to_h
  data.keys.sort.each do | key | 
    data[key] = sort_hash(data[key])
  end
  return data
end

opcodes_data["opcodes"] = sort_hash(opcodes_data["opcodes"])
%w{groups isa}.each do | top_key |
  opcodes_data[top_key] = sort_hash_list(opcodes_data[top_key])
end
opcodes_data["sections"] = sort_hash_hash_list(opcodes_data["sections"])
opcodes_data["sections_labels"] = sort_hash_hash(opcodes_data["sections_labels"])

File.open(options[:opcodes_yaml_out],"w") do | fout |
  fout.write(opcodes_data.to_yaml)
end
