class Otwtranslation::LanguagesController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only

  def index
    @languages = Language.all
  end

  def show
    @language = Language.find_by_short(params[:id])
  end

  def new
    
  end

end

