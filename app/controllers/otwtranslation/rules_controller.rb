class Otwtranslation::RulesController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only, :except => :select


  def new
    @rule = Otwtranslation::ContextRule.new
  end

  def create
    p params
  end

  
end

