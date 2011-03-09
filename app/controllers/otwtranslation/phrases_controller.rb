class Otwtranslation::PhrasesController < ApplicationController

  def index
    @phrases = Otwtranslation::Phrase.all
  end

  def show
    @phrase = Otwtranslation::Phrase.find_by_key(params[:id])
  end

end

