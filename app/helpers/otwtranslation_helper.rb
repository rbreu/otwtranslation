module OtwtranslationHelper

  def ts(phrase)
    return phrase
  end
  
  def t(id, params={})
    warn "[DEPRECATION WARNING] 't' is deprecated. Use 'ts' instead."
    phrase = params.delete(:default) || "FIXME"
    return phrase % params
  end
  
end

