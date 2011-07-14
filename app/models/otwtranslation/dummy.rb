class Otwtranslation::Dummy

  NAME = "DUMMY"
  
  def method_missing(symbol, *arguments, &block)
    return self
  end

  def to_s
    NAME
  end
  
  def gsub(*args)
    NAME
  end
  
end
