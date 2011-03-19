class Otwtranslation::TranslationsController < ApplicationController
  include Otwtranslation::CommonMethods
  include OtwtranslationHelper
  
  before_filter :otwtranslation_only

  def new
    @phrase = Otwtranslation::Phrase.find_from_cache_or_db(params[:id])
    @translation = Otwtranslation::Translation.new(:phrase_key => params[:id])
  end

  def create
    @translation = Otwtranslation::Translation.new(params[:otwtranslation_translation])
    @phrase = Otwtranslation::Phrase.find_by_key(params[:id])
    @translation.phrase = @phrase
    @translation.sources << @phrase.sources
    @translation.language_short = otwtranslation_language
    
    if @translation.save
      flash[:notice] =  ts('Translation successfully created.')
      redirect_to otwtranslation_phrase_path(@phrase)
    else
      flash[:error] = ts('There was a problem saving the translation.')
      redirect_to otwtranslation_new_translation_path(@phrase)
    end
  end

end

