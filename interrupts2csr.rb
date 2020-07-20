require 'yaml'
interrupts = YAML.load_file('interrupts.yaml')
csrs = YAML.load_file('csr.yaml')

# update these registers
# mie, mip, sie, sip, uie, uip

def check_level(max, current)
  if max == "u"
    return current == "u"
  end
  if max == "s"
    return %w{u s}.include?(current)
  end
  # OK
  return TRUE
end

DESC = {
  "ie" => "Interrupt enable",
  "ip" => "Interrupt pending",
}

%w{m s u}.each do | level |


  
  %w{ie ip}.each do | reg |
    
    interrupts["interrupts"].each do | interrupt |

      csr_name = "#{level}#{reg}"
      interrupt_name = interrupt["name"]

      if check_level(level, interrupt_name[0])

        if csrs["regs"].include?csr_name
          
          csrs["regs"][csr_name]["fields"] ||= {}
          if not csrs["regs"][csr_name]["fields"].include?(interrupt_name)
            
            if interrupt["idx"] == "16+"
              bits = ["mxlen",16]
            else
              bits = [interrupt["idx"].to_i]
            end

            field_info = {
              "desc" => "#{DESC[reg]}: #{interrupt['desc']}",
              "bits" => bits,
            }
            csrs["regs"][csr_name]["fields"][interrupt_name] = field_info
            print "#{csr_name}.#{interrupt_name} = #{field_info.to_yaml}\n"
            
          end

        end

      end
      
    end

  end
  
end

File.open('csr.yaml', 'wb') do | fout |
  fout.write(csrs.to_yaml)
end

