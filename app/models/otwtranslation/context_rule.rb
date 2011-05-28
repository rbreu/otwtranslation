include ActionView::Helpers::TextHelper
  
class Otwtranslation::ContextRule < ActiveRecord::Base

  set_table_name :otwtranslation_context_rules

  belongs_to(:language, :class_name => 'Otwtranslation::Language',
             :primary_key => 'short', :foreign_key => 'language_short')

  # Condtions:
  # Array of [condition name, param_list], e.g.
  # [["ends with", ["s", "x"], ["starts with", ["A", "a"]]]
  # A rule if all condition matches. Rules without conditions always match.
  serialize :conditions

  # Actions:
  # Array of [action, params], e.g.
  # [["append", {"suffix" => "s"}]]
  # A rule if all condition matches. Rules without conditions always match.
  # Actions are processed in order.
  serialize :actions

  acts_as_list :scope => 'language_short = \'#{language_short}\' AND type = \'#{type}\''

  validates_presence_of :language_short

  @@RULE_TYPES = ["general", "list", "quantity"]
  cattr_accessor :RULE_TYPES

  CONDITIONS =  {
      "is" => "is?",
      "is not" => "is_not?",
      "ends with" => "ends_with?",
      "does not end with" => "not_ends_with?",
      "starts with" => "starts_with?",
      "does not start with" => "not_starts_with?",
      "is lesser/equal than" => "is_le?",
      "is greater than" => "is_gt?",
      "matches all" => "matches_all",
  }

  ACTIONS =  {
      "replace" => "replace",
      "append" => "append",
      "prepend" => "prepend",
      "auto pluralize" => "auto_pluralize"
  }


  ############################################################
  # Definition of conditions:
  
  def self.condition_matches_all(value, params)
    return all
  end
    
  def self.condition_is?(value, params)
    match = false
    params.each { |param| match ||= (value.to_s == param) }
    return match
  end
    
  def self.condition_is_not?(value, params)
    match = true
    params.each { |param| match &&= (value.to_s != param) }
    return match
  end

  def self.condition_ends_with?(value, params)
    match = false
    params.each { |param| match ||= (value.to_s.ends_with?(param)) }
    return match
  end

  def self.condition_not_ends_with?(value, params)
    match = true
    params.each { |param| match &&= (!value.to_s.ends_with?(param)) }
    return match
  end

  def self.condition_starts_with?(value, params)
    match = false
    params.each { |param| match ||= (value.to_s.starts_with?(param)) }
    return match
  end

  def self.condition_not_starts_with?(value, params)
    match = true
    params.each { |param| match &&= (!value.to_s.starts_with?(param)) }
    return match
  end

  def self.condition_is_le?(value, params)
    match = false
    params.each { |param| match ||= (value <= param.to_i) }
    return match
  end

  def self.condition_is_gt?(value, params)
    match = false
    params.each { |param| match ||= (value > param.to_i) }
    return match
  end

  ############################################################
  # Definition of actions:
  
  def self.action_replace(name, value, params)
    params[:replacement]
  end
  
  def self.action_append(name, value, params)
    value.to_s + params[:suffix]
  end
  
  def self.action_prepend(name, value, params)
    params[:prefix] + value.to_s
  end
  
  def self.action_auto_pluralize(name, value, params)
    pluralize(value, name)
  end
  

  ############################################################

  def self.parse_param_list(param)
    param.split(/\s*,\s*/)
  end

  
  # A rule matches if all conditions match
  # A rule with no conditions doesn't match
  def match?(value)
    return false if conditions.empty?

    conditions.each do |condition, params|
      return false unless
        self.class.send("condition_#{self.class::CONDITIONS[condition]}",
                        value, params)
    end
    return true
  end


  def self.rules_for(language, type=nil)
    if type.nil?
      where(:language_short => language).order(:type, :position)
    else
      where(:language_short => language,
            :type => "Otwtranslation::#{type.to_s.capitalize}Rule")
        .order(:position)
    end
  end

  def display_type
    type.gsub(/Otwtranslation::(.*)Rule/, '\1').downcase
  end


  def perform_actions(name, value)
    actions.each do |action, params|
      value = self.class.send("action_#{self.class::ACTIONS[action]}",
                              name, value, params)
    end

    return value
  end


  def self.apply_rule(language, content, variables)
    variable = content[:variable]
    value = variables[content[:variable].to_sym]
    
    return Otwtranslation::Tokenizer.rule_to_s(content) if value.nil?
    
    rules_for(language, content[:name]).each do |rule|
      return rule.perform_actions(variable, value) if rule.match?(value)
    end
    
    return value.to_s
  end
    
  

  def self.apply_rules(label, language, variables={})
    applied = ""

    Otwtranslation::Tokenizer.tokenize_label(label).each do |token, content|
      if token == :text
        applied += content
      else
        applied += apply_rule(language, content, variables)
      end
    end

    return applied
  end

end
