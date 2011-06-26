module OtwtranslationHelper

  def ts(phrase, description="", variables = {})

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
      return otwtranslation_decorated_translation(phrase.key, phrase.label, variables)
    else
      return Otwtranslation::ContextRule.apply_rules(phrase.label, otwtranslation_language, variables).html_safe
    end
    
  end


  def otwtranslation_decorated_translation(phrase_key, phrase_label=nil, variables={})
    cache_key = Otwtranslation::Translation
      .cache_key(phrase_key, otwtranslation_language, [], true)
    markup = Rails.cache.read(cache_key)
    return markup.html_safe if markup

    if phrase_label.nil?
      phrase_label = Otwtranslation::Phrase.find_by_key(phrase_key).label
    end
    
    all_text = Otwtranslation::ContextRule.label_all_text?(phrase_label)

    if transl = Otwtranslation::Translation
        .where(:phrase_key => phrase_key, :approved => true)
        .for_context(phrase_label, otwtranslation_language, variables).first
      span_class = 'approved'
      landmark = ""
      if all_text
        label = transl.label
      else
        label = Otwtranslation::ContextRule.apply_rules(transl.label,
                                                        otwtranslation_language,
                                                        variables)
      end
    elsif transl = Otwtranslation::Translation
        .where(:phrase_key => phrase_key)
        .for_context(phrase_label, otwtranslation_language, variables).first
      span_class = 'translated'
      landmark = '<span class="landmark">review</span>'
      if all_text
        label = transl.label
      else
        label = Otwtranslation::ContextRule.apply_rules(transl.label,
                                                        otwtranslation_language,
                                                        variables)
      end
        
    else
      span_class = 'untranslated'
      landmark = '<span class="landmark">translate</span>'
      if all_text
        label = "*" + phrase_label
      else
        label = "*" + Otwtranslation::ContextRule.apply_rules(phrase_label,
                                                              OtwtranslationConfig.DEFAULT_LANGUAGE,
                                                              variables)
      end
    end

    markup = "<span id=\"otwtranslation_phrase_#{phrase_key}\" class=\"#{span_class}\">#{landmark}#{label}</span>"

    Rails.cache.write(cache_key, markup) if all_text
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

