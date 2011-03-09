module OtwtranslationHelper

  def ts(phrase, description="")
    Otwtranslation::Phrase.find_or_create(phrase, description)

    
    #puts request.url
    #puts "#{controller.class.name.underscore.gsub("_controller", "")}##{controller.action_name}"
    
    return phrase
  end
  
  def t(id, params={})
    warn "[DEPRECATION WARNING] 't' is deprecated. Use 'ts' instead."
    phrase = params.delete(:default) || "FIXME"
    # return ts(phrase % params) # bad, might generate gazillions of phrases...
    return phrase % params
  end

end

