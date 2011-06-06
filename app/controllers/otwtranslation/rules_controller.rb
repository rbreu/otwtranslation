class Otwtranslation::RulesController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only, :except => :select


  def new
    @rule = Otwtranslation::ContextRule.new(params[:otwtranslation_context_rule])
  end

  def create
    @rule = Otwtranslation::ContextRule.new(params[:otwtranslation_context_rule])

    # OMG refactor! and write tests!
    
    conditions = []
    @rule.conditions.each_slice(2) do |condition, parameters|
      parameters = Otwtranslation::ParameterParser.tokenize(parameters)
      conditions << [condition, parameters] unless condition.blank?
    end
    @rule.conditions = conditions
    
    actions = []
    @rule.actions.each_slice(2) do |action, parameters|
      parameters = Otwtranslation::ParameterParser.tokenize(parameters)
      actions << [action, parameters] unless action.blank?
    end
    @rule.actions = actions

    logger.info @rule.conditions
    logger.info @rule.actions
    

    redirect_to otwtranslation_language_path(@rule.language_short)
  end

  
end

