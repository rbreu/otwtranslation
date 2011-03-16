class Otwtranslation::LanguagesController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only, :except => :select


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
      flash[:notice] =  ts('Language successfully created.')
      redirect_to otwtranslation_language_path(@language)
    else
      flash[:error] = ts('There was a problem saving the language.')
      render :action => "new"
    end
  end

  
  def select
    session[:otwtranslation_language] = params[:otwtranslation_language]
    redirect_to :back
  end
  
end

