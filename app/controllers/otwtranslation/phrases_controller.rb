class Otwtranslation::PhrasesController < ApplicationController
  include Otwtranslation::CommonMethods
  include OtwtranslationHelper

  before_filter :otwtranslation_only

  def index
    @phrases = Otwtranslation::Phrase.paginate(:page => params[:page])
  end

  def show
    @phrase = Otwtranslation::Phrase.find_by_key(params[:id])
    @sources = @phrase.sources.paginate(:page  => params[:page], :per_page => 10)
    @translations = @phrase.translations.for_language(otwtranslation_language)

    respond_to do |format|
      format.html
      format.js { render '_show_inline', :translations => @translations }
    end
  end

end

