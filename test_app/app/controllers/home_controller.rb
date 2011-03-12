class HomeController < ApplicationController

  def index
  end

  def new_user
    user = User.new
    user.login = params['name']
    user.email = 'test@example.org'
    user.password = 'test123'
    flash[:error] = ts('Ooops.') unless user.save
    redirect_to ''
  end
  

end
