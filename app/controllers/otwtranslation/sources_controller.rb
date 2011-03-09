class Otwtranslation::SourcesController < ApplicationController

  def index
    @sources = Otwtranslation::Source.all
  end

  def show
    @source = Otwtranslation::Source.find(params[:id])
  end

end

