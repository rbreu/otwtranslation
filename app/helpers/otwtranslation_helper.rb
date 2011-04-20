module OtwtranslationHelper

  def ts(phrase, description="")

    # Try to store this phrase
    begin
      # Maybe we got called from a view
      source = {
        :controller => controller.class.name.underscore.gsub("_controller", ""),
        :action => controller.action_name,
        :url => request.url
      }
    rescue NameError
      # OK, so we got called from a controller
      source = {
        :controller => self.class.name.underscore.gsub("_controller", ""),
        :action => action_name,
        :url => request.url
      }
    end

    phrase = Otwtranslation::Phrase.find_or_create(phrase, description, source)

    # See if we need to present a decorated or plain translation
    if otwtranslation_tool_visible? && otwtranslation_language != OtwtranslationConfig.DEFAULT_LANGUAGE
      return otwtranslation_decorated_translation(phrase.key)
    else
      return phrase.label
    end
    
  end


  def otwtranslation_decorated_translation(phrase_key)
    
    markup = Rails.cache.read("otwtranslation_for_translator_#{otwtranslation_language}_#{phrase_key}")
    return markup.html_safe if markup
      
    phrase = Otwtranslation::Phrase.find_by_key(phrase_key)
    
    if transl = phrase.approved_translations_for(otwtranslation_language).first
      span_class = 'approved'
      landmark = ""
      label = transl.label
    elsif transl = phrase.translations_for(otwtranslation_language).first
      span_class = 'translated'
      landmark = '<span class="landmark">review</span>'
      label = transl.label
    else
      span_class = 'untranslated'
      landmark = '<span class="landmark">translate</span>'
      label = "*" + phrase.label
    end

    markup = "<span id=\"otwtranslation_phrase_#{phrase_key}\" class=\"#{span_class}\">#{landmark}#{label}</span>"
    Rails.cache.write("otwtranslation_for_translator_#{otwtranslation_language}_#{phrase_key}", markup)

    return markup.html_safe
  end
 
  
  def t(id, params={})
    warn "[DEPRECATION WARNING] 't' is deprecated. Use 'ts' instead."
    phrase = params.delete(:default) || "FIXME"
    # return ts(phrase % params) # bad, might generate gazillions of phrases...
    return phrase % params
  end


  def otwtranslation_language_selector
    render :partial => 'otwtranslation/languages/selector'
  end
  

  def otwtranslation_tool_toggler
    if logged_in? && current_user.is_translation_admin?
      label = session[:otwtranslation_tools] ? 'Disable Translation Tools' :
        'Enable Translation Tools'
      return link_to(ts(label),
                       :controller => otwtranslation_toggle_tools_path)
    else
      return ""
    end
  end

  def otwtranslation_tool_visible?
    logged_in? && current_user.is_translation_admin? && session[:otwtranslation_tools]
  end

  def otwtranslation_tool_header
    if otwtranslation_tool_visible?
      render :partial => 'otwtranslation/home/tools'
    end
  end


  def otwtranslation_language
    session[:otwtranslation_language] || OtwtranslationConfig.DEFAULT_LANGUAGE
  end

end

