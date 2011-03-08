class Otwtranslation::PhrasesController < ApplicationController

  def index
    @phrases = Otwtranslation::Phrase.all
  end

  def show
    @phrase = Phrase.find_by_key(params[:key])
  end

end

