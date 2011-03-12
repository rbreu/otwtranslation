class HomeController < ApplicationController

  def index
  end

  def new_user
    user = User.new
    user.login = params['name']
    user.email = 'test@example.org'
    user.password = 'test123'
    user.
    flash[:error] = ts('Ooops.') unless user.save
    redirect_back_or_default('/home')
  end
  
  def set_translation_admin
    if params['commit'] == "Remove"
      current_user.translation_admin = false
      current_user.save
    else
      current_user.translation_admin = true
      current_user.save
    end
    redirect_back_or_default('/home')
  end
  

end
