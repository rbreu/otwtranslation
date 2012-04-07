class HomeController < ApplicationController

  def index
  end

  # def new_user
  #   user = User.new
  #   user.login = params['name']
  #   user.email = "#{params['name']}@example.org"
  #   user.password = 'test123'
  #   user.password_confirmation = 'test123'
  #   flash[:error] = "Ooops: #{user.errors}" unless user.save
  #   redirect_to :back
  # end
  
  # def set_translation_admin
  #   if params['commit'] == "Remove"
  #     current_user.translation_admin = false
  #     current_user.save
  #   else
  #     current_user.translation_admin = true
  #     current_user.save
  #   end
  #   redirect_to :back
  # end
  

end
