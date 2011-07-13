class Otwtranslation::Dummy

  def method_missing(symbol, *arguments, &block)
    return self
  end

  def to_s
    "DUMMY"
  end
  
  def gsub(*args)
    "DUMMY"
  end
  
end
