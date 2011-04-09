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

    # See if we need to present a translation
    if otwtranslation_tool_visible? && otwtranslation_language != OtwtranslationConfig.DEFAULT_LANGUAGE
      return otwtranslation_decorated_translation(phrase.key)
    else
      return phrase.label
    end
    
  end


  def otwtranslation_decorated_translation(phrase_key)
    
    # TODO: performance!!!!
    phrase = Otwtranslation::Phrase.find_by_key(phrase_key)
    
    
    display_phrase = "<span id=\"otwtranslation_phrase_#{phrase.key}\" class=\"otwtranslation_mark_"
      
    if transl = phrase.approved_translations_for(otwtranslation_language).first
        display_phrase += "approved\">#{transl.label}</span>"
    elsif transl = phrase.translations_for(otwtranslation_language).first
      display_phrase += "translated\">#{transl.label}</span>"
    else
      display_phrase += "untranslated\">#{phrase.label}</span>"
    end

    return display_phrase.html_safe
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


  def otwtranslation_classes_for_main
    otwtranslation_tool_visible? ? "translator" : ""
  end
  
end

