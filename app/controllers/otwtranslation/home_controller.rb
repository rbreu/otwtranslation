class Otwtranslation::HomeController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only

  def index
    @languages = Otwtranslation::Assignment.assignees_language_names(current_user)
    @assignments = Otwtranslation::Assignment
      .activated_for(current_user, otwtranslation_language).paginate(:page => params[:page])
  end

  def toggle_tools
    session[:otwtranslation_tools] = !session[:otwtranslation_tools]
    redirect_to :back
  end
  
end

