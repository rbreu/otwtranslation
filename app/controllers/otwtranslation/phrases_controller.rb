class Otwtranslation::PhrasesController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only

  def index
    @phrases = Otwtranslation::Phrase.all
  end

  def show
    @phrase = Otwtranslation::Phrase.find_by_key(params[:id])
  end

end

