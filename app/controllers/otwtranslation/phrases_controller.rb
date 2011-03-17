class Otwtranslation::PhrasesController < ApplicationController
  include Otwtranslation::CommonMethods
  include OtwtranslationHelper

  before_filter :otwtranslation_only

  def index
    @phrases = Otwtranslation::Phrase.all
  end

  def show
    @phrase = Otwtranslation::Phrase.find_by_key(params[:id])
    @translations = @phrase.translations_for(otwtranslation_language)
  end

end

