class Otwtranslation::HomeController < ApplicationController

  def index
  end

  def toggle_tools
    session[:otwtranslation_tools] = !session[:otwtranslation_tools]
    redirect_to :back
  end
  
end

