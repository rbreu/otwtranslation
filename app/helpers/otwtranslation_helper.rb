module OtwtranslationHelper

  def ts(phrase, description="")

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

    Otwtranslation::Phrase.find_or_create(phrase, description, source)
                        
    return phrase
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

  def otwtranslation_tool_header
    if logged_in? && current_user.is_translation_admin? && session[:otwtranslation_tools]
      render :partial => 'otwtranslation/home/tools'
    end
  end
  
end

