class Otwtranslation::TranslationsController < ApplicationController
  include Otwtranslation::CommonMethods
  include OtwtranslationHelper
  
  before_filter :otwtranslation_only

  def new
    @phrase = Otwtranslation::Phrase.find_by_key(params[:id])
    @existing_translations = @phrase.translations_for(otwtranslation_language)
    @translation = Otwtranslation::Translation.new(:phrase_key => params[:id])
  end

  def create
    @translation = Otwtranslation::Translation.new(params[:otwtranslation_translation])
    @translation.phrase_key = params[:id]
    @translation.language_short = otwtranslation_language
    
    if @translation.save
      flash[:notice] =  ts('Translation successfully created.')
      redirect_to otwtranslation_phrase_path(params[:id])
    else
      msg = 'There was a problem saving the translation:' +
        prettify_error_messages(@translation) 
      flash[:error] = msg.html_safe
      redirect_to otwtranslation_new_translation_path(params[:id])
    end
  end

  def approve
    @translation = Otwtranslation::Translation.find(params[:id])
    @translation.approved = true
    
    unless @translation.save
      msg = 'There was a problem saving the translation:' +
        prettify_error_messages(@translation) 
      flash[:error] = msg.html_safe
      @translation.approved = false
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
      
  end


  def confirm_disapprove
    @translation = Otwtranslation::Translation.find(params[:id])
    render "confirm_disapprove"
  end


  def disapprove
    @translation = Otwtranslation::Translation.find(params[:id])
    @translation.approved = false
    
    unless @translation.save
      msg = 'There was a problem saving the translation:' +
        prettify_error_messages(@translation) 
      flash[:error] = msg.html_safe
      @translation.approved = true
    end
    
    redirect_to otwtranslation_phrase_path(@translation.phrase_key)
  end

end

