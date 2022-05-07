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

  %w{cause}.each do | reg |
    
    csr_name = "#{level}#{reg}"
    if csrs["regs"].include?csr_name
      
      interrupts["exceptions"].each do | exception |
        if exception["modes"].include?level
          
          if not csrs["regs"][csr_name]["fields"]["exception_code"].include?("enums")
            csrs["regs"][csr_name]["fields"]["exception_code"]["enums"] = {}
          end    
          
          csrs["regs"][csr_name]["fields"]["exception_code"]["enums"][exception["macro"]] = exception["value"]

        end
        
      end
    end
  end

  %w{cause}.each do | reg |
    
    csr_name = "#{level}#{reg}"
    if csrs["regs"].include?csr_name

      if not csrs["regs"][csr_name]["fields"]["interrupt_code"].include?("enums")
        csrs["regs"][csr_name]["fields"]["interrupt_code"]["enums"] = {}
      end    

      interrupts["interrupts"].each do | interrupt |
        interrupt_name = interrupt["name"]
        if check_level(level, interrupt_name[0])
          csrs["regs"][csr_name]["fields"]["interrupt_code"]["enums"][interrupt_name] = interrupt["idx"]
        end

      end

    end

  end
  
  %w{ie ip}.each do | reg |

    interrupts["interrupts"].each do | interrupt |

      csr_name = "#{level}#{reg}"
      interrupt_name = interrupt["name"]

      if check_level(level, interrupt_name[0])

        if csrs["regs"].include?csr_name
          
          custom=FALSE
          if interrupt.include?('custom')
            custom = interrupt['custom'] 
          end
          
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
              "custom" => custom,
            }
            csrs["regs"][csr_name]["fields"][interrupt_name] = field_info
            print "#{csr_name}.#{interrupt_name} = #{field_info.to_yaml}\n"
            
          else
            csrs["regs"][csr_name]["fields"][interrupt_name]['custom'] = custom
            
          end

        end

      end
      
    end

  end
  
end

File.open('csr.yaml', 'wb') do | fout |
  fout.write(csrs.to_yaml)
end

