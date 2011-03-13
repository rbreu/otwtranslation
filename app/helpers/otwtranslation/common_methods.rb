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
  
end

