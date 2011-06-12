class Otwtranslation::RulesController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only, :except => :select


  def new
    @rule = Otwtranslation::GeneralRule.new(params[:otwtranslation_context_rule])
  end

  def edit
    @rule = Otwtranslation::ContextRule.find(params[:id])
  end


  def update
    
    @rule = Otwtranslation::ContextRule.find(params[:id])
    @rule.description = params[:otwtranslation_context_rule][:description]
    @rule.conditions = trim_condition_action_params(params[:otwtranslation_context_rule][:conditions])
    @rule.actions = trim_condition_action_params(params[:otwtranslation_context_rule][:actions])
    
    if @rule.save
      redirect_to otwtranslation_language_path(@rule.language_short)
    else
      msg = 'There was a problem saving the rule:' +
        prettify_error_messages(@rule)
      flash[:error] = msg.html_safe
      render(:action => 'edit') && return 
    end
  end

  def create
    type = "#{params[:otwtranslation_context_rule][:type].capitalize}Rule"
    @rule = Otwtranslation.const_get(type).new(params[:otwtranslation_context_rule])

    @rule.conditions = trim_condition_action_params(@rule.conditions)
    @rule.actions = trim_condition_action_params(@rule.actions)

    render(:action => 'new') && return if params[:commit].downcase == "set type"

    if @rule.save
      redirect_to otwtranslation_language_path(@rule.language_short)
    else
      msg = 'There was a problem saving the rule:' +
        prettify_error_messages(@rule)
      flash[:error] = msg.html_safe
      render(:action => 'new') && return 
    end
  end


  def confirm_destroy
    @rule = Otwtranslation::ContextRule.find(params[:id])
  end

  
  def destroy
    rule = Otwtranslation::ContextRule.find(params[:id])
    rule.destroy
    redirect_to otwtranslation_language_path(rule.language_short)
  end
  

  def trim_condition_action_params(p)
    trimmed = []
    p.each_slice(2) do |name, parameters|
      parameters = Otwtranslation::ParameterParser.tokenize(parameters)
      trimmed << [name, parameters] unless name.blank?
    end
    return trimmed
  end
end

