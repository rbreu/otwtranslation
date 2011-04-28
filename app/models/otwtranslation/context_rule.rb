class Otwtranslation::ContextRule < ActiveRecord::Base

  include ActionView::Helpers::TextHelper
  
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

  validates_presence_of :language

  @@CONDITIONS = {
    "is" => "is?",
    "is not" => "is_not?",
    "ends with" => "ends_with?",
    "does not end with" => "not_ends_with?",
    "starts with" => "starts_with?",
    "does not start with" => "not_starts_with?",
    "has lesser/equal elements than" => "has_le_elements?",
    "has number of elements" => "has_number_elements?",
    "has more elements than" => "has_gt_elements?",
    "is lesser/equal than" => "is_le?",
    "is greater than" => "is_gt?"
  }

  @@ACTIONS = {
    "replace" => { :params => ["replacement"], :function => "replace" },
    "append" => { :params => ["suffix"], :function => "append" },
    "prepend" => { :params => ["prefix"], :function => "prepend" },
    "auto pluralize" => { :params => [], :function => "auto_pluralize" },
    "list replace" => {
      :params => ["words_connector",
                  "two_words_connector",
                  "last_word_connector"],
      :function => "list_replace" }
    }


  ############################################################
  # Definition of conditions:
  
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

  def self.condition_has_le_elements?(value, params)
    match = false
    params.each { |param| match ||= (value.length <= param.to_i) }
    return match
  end

  def self.condition_has_number_elements?(value, params)
    match = false
    params.each { |param| match ||= (value.length == param.to_i) }
    return match
  end

  def self.condition_has_gt_elements?(value, params)
    match = false
    params.each { |param| match ||= (value.length > param.to_i) }
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
    params["replacement"]
  end
  
  def self.action_append(name, value, params)
    value.to_s + params["suffix"]
  end
  
  def self.action_prepend(name, value, params)
    params["prefix"] + value.to_s
  end
  
  def self.action_auto_pluralize(name, value, params)
    pluralize(value, name) 
  end
  
  def self.action_list_replace(name, value, params)
    value.to_sentence(params)
  end

  ############################################################

  def self.parse_param_list(param)
    param.split(/\s*,\s*/)
  end

  
  # A rule matches if all conditions match
  # A rule with no conditions always matches
  def match?(value)
    conditions.each do |condition, params|
      return false unless
        self.class.send("condition_#{@@CONDITIONS[condition]}", value, params)
    end
    return true
  end
  
end
