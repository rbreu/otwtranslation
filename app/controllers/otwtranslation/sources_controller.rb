class Otwtranslation::SourcesController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only

  def index
    @sources = Otwtranslation::Source.all
  end

  def show
    @source = Otwtranslation::Source.find(params[:id])
  end

end

