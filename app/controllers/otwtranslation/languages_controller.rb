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
    @language = Language.new
  end

  def create
    @language = Language.new(params[:language])

    if @language.save
      puts "yes=============================================================="
      redirect_to(otwtranslation_language_path(@language),
                  :notice => ts('Language successfully created.'))
    else
      puts "no============================================================="
      render :action => "new"
    end
  end
  
end
