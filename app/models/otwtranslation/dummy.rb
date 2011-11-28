class Otwtranslation::Dummy

  NAME = "DUMMY"
  
  def method_missing(symbol, *arguments, &block)
    return self
  end

  def to_s
    NAME
  end
  
  def to_str
    NAME
  end
  
  def gsub(*args)
    NAME
  end

  def self.method_missing(symbol, *arguments, &block)
    return self.new
  end

end
