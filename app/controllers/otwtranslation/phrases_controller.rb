class Otwtranslation::PhrasesController < ApplicationController

  def index
    @phrases = Otwtranslation::Phrase.all
  end

end

