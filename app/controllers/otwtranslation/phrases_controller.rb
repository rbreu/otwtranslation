class Otwtranslation::PhrasesController < ApplicationController
  include Otwtranslation::CommonMethods
  include OtwtranslationHelper

  before_filter :otwtranslation_only

  def index
    @phrases = Otwtranslation::Phrase.paginate(:page => params[:page])
  end

  def show
    @phrase = Otwtranslation::Phrase.find_by_key(params[:id])
    @translations = @phrase.translations.for_language(otwtranslation_language)

    respond_to do |format|
      format.html
      format.js { render :partial => 'show_inline',
        :locals => { :translations => @translations } }
    end
  end

end

