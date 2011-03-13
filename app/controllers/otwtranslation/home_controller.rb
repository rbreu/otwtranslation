class Otwtranslation::HomeController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only

  def index
  end

  def toggle_tools
    session[:otwtranslation_tools] = !session[:otwtranslation_tools]
    redirect_to :back
  end
  
end

