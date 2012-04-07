module Otwtranslation::CommonMethods
  
  def otwtranslation_only
    unless logged_in? && current_user.is_translation_admin?

      flash[:error] = ts("I'm sorry, only translators and translation admins can look at that area.")
      redirect_to root_path
      return false
    else
      return true
    end
  end

  
  def prettify_error_messages(obj)
    msg =  ['<ul>']
    obj.errors.each do |attribute, message|
      msg += ["<li>#{attribute.capitalize}: #{message}</li>"]
    end
    msg += ['</ul>']
    return msg.join("\n").html_safe
  end

  
end

