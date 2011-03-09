module OtwtranslationHelper

  def ts(phrase, description="")

    ctrl = controller.class.name.underscore.gsub("_controller", "")
    action = controller.action_name
    
    Otwtranslation::Phrase.find_or_create(phrase, description,
                                          "#{ctrl}##{action}", request.url)
                    
    #puts Rails.application.routes.recognize_path('/', :method => :get )
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

