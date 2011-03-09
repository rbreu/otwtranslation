module OtwtranslationHelper

  def ts(phrase, description="")

    source = {
      :controller => controller.class.name.underscore.gsub("_controller", ""),
      :action => controller.action_name,
      :url => request.url
    }
    
    Otwtranslation::Phrase.find_or_create(phrase, description, source)
                        
    return phrase
  end
  
  def t(id, params={})
    warn "[DEPRECATION WARNING] 't' is deprecated. Use 'ts' instead."
    phrase = params.delete(:default) || "FIXME"
    # return ts(phrase % params) # bad, might generate gazillions of phrases...
    return phrase % params
  end

end

