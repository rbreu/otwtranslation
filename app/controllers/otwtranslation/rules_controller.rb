class Otwtranslation::RulesController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only, :except => :select


  def new
    @rule = Otwtranslation::ContextRule.new
  end

  def create
    @language = Otwtranslation::Language.new(params[:otwtranslation_language])

    if @language.save
      flash[:notice] =  ts('Language successfully created.')
      redirect_to otwtranslation_language_path(@language)
    else
      msg = 'There was a problem saving the language:' +
        prettify_error_messages(@language) 
      flash[:error] = msg.html_safe
      render :action => "new"
    end
  end

  
end

