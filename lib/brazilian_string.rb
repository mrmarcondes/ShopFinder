# encoding: UTF-8
#shairon.toledo@gmail.com 08/03/2007


module BrazilianString

    ACENTOS_MINUS="ãàáâäèéêëìíîïõòóôöùúûüç"
    ACENTOS_MAIUS="ÃÀÁÂÄÈÉÊËÌÍÎÏÖÒÓÔÙÚÛÜÇ"
  
    SEM_ACENTOS_MINUS="aaaaaeeeeiiiiooooouuuuc"  
    SEM_ACENTOS_MAIUS="AAAAAEEEEIIIIOOOOUUUUC"  
  
    ACENTOS=ACENTOS_MINUS+ACENTOS_MAIUS
    SEM_ACENTOS=SEM_ACENTOS_MINUS+SEM_ACENTOS_MAIUS
  def desacentualize
      self.tr(ACENTOS,SEM_ACENTOS)
  end
  
  def br_downcase
     if  self =~ %r{["#{ACENTOS_MAIUS}"]}
          self.downcase.tr(ACENTOS_MAIUS, ACENTOS_MINUS)
     else
         self.downcase
     end

  end

  def br_upcase
     
     if  self =~ %r{["#{ACENTOS_MINUS}"]}
          self.upcase.tr(ACENTOS_MINUS, ACENTOS_MAIUS)
     else
         self.upcase
     end

  end

    def br_match(exp)
      v=exp.source.gsub(/(a-z)/, '\1'+ACENTOS_MINUS)
      v.gsub!(/(A-Z)/, '\1'+ACENTOS_MAIUS)
      v.gsub!(/(\\w)/, '[\1'+ACENTOS+"]")
      v.gsub!(/(\\W)/, "[^a-zA-Z0-9_#{ACENTOS}]")
     
     return self =~ Regexp.new(v)
   end
end

class String 

include BrazilianString

end

#Exemplos o À é figurante :)

#puts "joão fez um círculo e um ângulo sem Á vétice?!"
#puts "joão fez um círculo e um ângulo sem Á vétice?!".desacentualize
#puts "joão fez um círculo e um ângulo sem Á vétice?!".br_downcase
#puts "joão fez um círculo e um ângulo sem Á vétice?!".br_upcase
#puts "ána".br_match /^\w/
#puts "ána" =~ /^\w/
