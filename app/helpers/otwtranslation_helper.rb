module OtwtranslationHelper

  def ts(phrase, variables = {})
    source = otwtranslation_get_source
    phrase = Otwtranslation::Phrase.find_or_create(phrase,
                                                   variables[:_description],
                                                   source)

    # Do we need to display a decorated translation for translators?
    if (otwtranslation_tool_visible? &&
        otwtranslation_language != OtwtranslationConfig.DEFAULT_LANGUAGE)
      return otwtranslation_decorated_translation(phrase.key, phrase.label, variables)
    end

    # Do we need to display a translation for normal users?
    if Otwtranslation::Language.translation_visible_for?(variables[:_user],
                                                         otwtranslation_language(variables[:_user]))
      return otwtranslation_translation(phrase.key, phrase.label, variables)
    end

    # Return the original phrase
    return Otwtranslation::ContextRule
        .apply_rules(phrase.label,  OtwtranslationConfig.DEFAULT_LANGUAGE, variables).html_safe
  end


  def otwtranslation_translation(phrase_key, phrase_label, variables)
    language = otwtranslation_language(variables[:_user])

    transl = Otwtranslation::Translation
      .approved_label_for_context(phrase_key, phrase_label, language, variables)

    #if Otwtranslation::ContextRule.label_all_text?(phrase_label)
    #  return (transl || phrase_label).html_safe
    #end
      
    if transl.nil?
      return Otwtranslation::ContextRule
        .apply_rules(phrase_label, OtwtranslationConfig.DEFAULT_LANGUAGE,
                     variables).html_safe
    else
      return Otwtranslation::ContextRule
        .apply_rules(transl, language, variables).html_safe
    end
      
  end


  def otwtranslation_get_source
    begin
      # Maybe we got called from a view
      source = {
        :controller => controller.class.name.underscore.gsub("_controller", ""),
        :action => controller.action_name,
        :url => request.url
      }
      return source
    rescue NameError
    end
      
    begin
      # Maybe we got called from a controller
      source = {
        :controller => self.class.name.underscore.gsub("_controller", ""),
        :action => action_name,
        :url => request.url
      }
      return source
    rescue NameError
    end

    begin
      # Maybe we got called from a mailer view
      source = {
        :controller => mailer.mailer_name,
        :action => action_name,
        :url => ""
      }
      return source
    rescue NameError
    end
      
    begin
      # Maybe we got called from a mailer
      source = {
        :controller => mailer_name,
        :action => action_name,
        :url => ""
      }
      return source
    rescue NameError
    end
      
    # Something else. Investigate.
    source = {
      :controller => "unknown",
      :action => "unknown",
      :url => ""
    }
    return source

  end
  

  def otwtranslation_decorated_translation(phrase_key, phrase_label=nil, variables={})

    cache_key = Otwtranslation::Translation
      .cache_key(phrase_key, otwtranslation_language, [])
    markup = Rails.cache.read(cache_key)
    return markup.html_safe if markup

    if phrase_label.nil?
      phrase_label = Otwtranslation::Phrase.find_by_key(phrase_key).label
    end
    
    all_text = Otwtranslation::ContextRule.label_all_text?(phrase_label)

    if transl =  Otwtranslation::Translation
      .approved_label_for_context(phrase_key, phrase_label, otwtranslation_language, variables)
      span_class = 'approved'
      landmark = ""
      if all_text
        label = transl
      else
        label = Otwtranslation::ContextRule
          .apply_rules(transl, otwtranslation_language, variables)
      end
    elsif transl = Otwtranslation::Translation
        .where(:phrase_key => phrase_key)
        .for_context(phrase_key, phrase_label, otwtranslation_language,
                     variables).first
      span_class = 'translated'
      landmark = '<span class="landmark">review</span>'
      if all_text
        label = "*" + transl.label
      else
        label = "*" + Otwtranslation::ContextRule
          .apply_rules(transl.label, otwtranslation_language, variables)
      end
        
    else
      span_class = 'untranslated'
      landmark = '<span class="landmark">translate</span>'
      if all_text
        label = "*" + phrase_label
      else
        label = "*" + Otwtranslation::ContextRule
          .apply_rules(phrase_label, OtwtranslationConfig.DEFAULT_LANGUAGE, variables)
      end
    end

    if variables[:_decorate_off]
      markup = label
    else
      markup = "<span id=\"otwtranslation_phrase_#{phrase_key}\" class=\"#{span_class}\">#{landmark}#{label}</span>"
    end

    Rails.cache.write(cache_key, markup) if all_text
    return markup.html_safe
  end
 
  
  def t(id, params={})
    #warn "[DEPRECATION WARNING] 't' is deprecated. Use 'ts' instead."
    phrase = params.delete(:default) || "FIXME"
    # return ts(phrase % params) # bad, might generate gazillions of phrases...
    return phrase % params
  end


  def otwtranslation_language_selector
    languages = Otwtranslation::Language.language_choices_for(current_user)
    render('otwtranslation/languages/selector', :languages => languages)
  end
  

  def otwtranslation_tool_toggler
    if logged_in? && current_user.is_translation_admin?
      if otwtranslation_tool_visible?
        return link_to('Disable Translation Tools',
                       url_for(:translating => false))
      else
        return link_to('Enable Translation Tools',
                       url_for(:translating => true))
      end
    else
      return ""
    end
  end

  def otwtranslation_tool_visible?
    begin
      return (logged_in? && current_user.is_translation_admin? &&
              Otwtranslation::Language.translation_tool_enabled)
    rescue NameError
      # This happens in emails
      return false
    end
  end

  def otwtranslation_tool_header
    if otwtranslation_tool_visible?
      source = Otwtranslation::Source.find_by_source(otwtranslation_get_source)
      render('otwtranslation/home/tools', :source => source)
    end
  end

  def otwtranslation_language(user=nil)
    begin
      language = params['locale']
    rescue NameError
      # This happens in emails. TODO: Get from user config.
      language = nil
    end
    language || OtwtranslationConfig.DEFAULT_LANGUAGE
  end
  
end

