class Otwtranslation::SourcesController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only

  def index
    @sources = Otwtranslation::Source.paginate(:page => params[:page])
  end

  def show
    @source = Otwtranslation::Source.find(params[:id])
    @phrases = @source.phrases.paginate(:page  => params[:page])
  end

end

