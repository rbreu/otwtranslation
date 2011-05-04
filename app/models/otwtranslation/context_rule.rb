include ActionView::Helpers::TextHelper
  
class Otwtranslation::ContextRule < ActiveRecord::Base

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

  set_table_name :otwtranslation_context_rules

  belongs_to(:language, :class_name => 'Otwtranslation::Language',
             :primary_key => 'short', :foreign_key => 'language_short')

  validates_presence_of :language_short
  
  
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


  def self.rules_for(language, type)
    where(:language_short => language,
          :type => "Otwtranslation::#{type.to_s.capitalize}Rule")
  end


  def perform_actions(name, value)
    actions.each do |action, params|
      value = self.class.send("action_#{self.class::ACTIONS[action]}",
                              name, value, params)
    end

    return value
  end
  

  def self.apply_rules(label, language, variables={})
    applied = ""

    Otwtranslation::Tokenizer.tokenize_label(label).each do |token, content|
      if token == :text
        applied += content
      else
        variable = content[:variable]
        value = variables[content[:variable].to_sym]
        if value.nil?
          applied += Otwtranslation::Tokenizer.rule_to_s(content)
          next
        end
        rules_for(language, content[:name]).each do |rule|
          if rule.match?(value)
            applied += rule.perform_actions(variable, value)
            break
          end
          
        end
      end
    end

    return applied
  end
  
end
