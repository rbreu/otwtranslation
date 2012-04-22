require 'polyglot'
require 'treetop'

Treetop.load(File.join(File.dirname(__FILE__), 'context_rules'))

class Otwtranslation::ContextRule < ActiveRecord::Base
  extend ActionView::Helpers::TextHelper

  self.table_name = :otwtranslation_context_rules

  belongs_to(:language, :class_name => 'Otwtranslation::Language',
             :primary_key => 'locale', :foreign_key => 'locale')


  # Condtions: Array of [condition name, param_list] pairs, e.g.
  # [["ends with", ["s", "x"], ["starts with", ["A", "a"]]]
  #
  # A rule matches if all condition match. Rules without conditions
  # always match.
  serialize :conditions

  # Actions: Array of [action, params] pairs, e.g.  [["append", ["s"]]]
  #
  # Actions are processed in order.
  serialize :actions

  acts_as_list :scope => 'locale = \'#{locale}\' AND type = \'#{type}\''

  validates_presence_of :locale
  validate :conditions_must_be_valid, :actions_must_be_valid

  attr_protected :description_sanitizer_version

  after_destroy :clean_cache_and_translations
  after_save :add_to_cache

  attr_protected :type
  
  @@context_parser = ContextRulesParser.new
  
  @@RULE_TYPES = ["general", "list", "possessive", "quantity"]
  cattr_accessor :RULE_TYPES

  CONDITIONS =  {
      "is" => "is?",
      "is not" => "is_not?",
      "ends with" => "ends_with?",
      "does not end with" => "not_ends_with?",
      "starts with" => "starts_with?",
      "does not start with" => "not_starts_with?",
      "is less than or equal" => "is_le?",
      "is greater than" => "is_gt?",
      "matches all" => "matches_all",
  }


  ACTIONS =  {
      "replace" => "replace",
      "remove last chars" => "remove_last_chars",
      "remove first chars" => "remove_first_chars",
      "append" => "append",
      "prepend" => "prepend",
      "auto pluralize" => "auto_pluralize"
  }


  after_initialize :init_actions_conditions

  def conditions_must_be_valid
    list_types_must_be_valid(:conditions)
  end

  def actions_must_be_valid
    list_types_must_be_valid(:actions)
  end

  def list_types_must_be_valid(type)
    attr = send(type)
    allowed = self.class.send(type)
    unless attr.is_a?(Array)
      errors.add(type, "Whole list must be Array, got #{attr.class.name}")
      return
    end
    
    attr.each do |a|
      unless (a.is_a?(Array) && a.size == 2)
        errors.add(type, "Element must be Array of size 2, got #{a.class.name}")
        return
      end
     
      errors.add(type, "No such type: #{a[0]}") unless allowed.include?(a[0])
      errors.add(type, "Parameters must be Array, got #{a[1].class.name}") unless a[1].is_a?(Array)
    end
  end

  def init_actions_conditions
    self.conditions ||= []
    self.actions ||= []
  end

  ############################################################

  def self.conditions
    self::CONDITIONS.keys.sort
  end
  
  def self.actions
    self::ACTIONS.keys.sort
  end
  
  def self.tokenize_label(label)
    @@context_parser.parse(label).content
  end

  def self.label_all_text?(label)
    tokenize_label(label).each do |token, content|
      return false if token != :text
    end
    return true
  end

  def self.rule_to_label(rule)
    "{#{rule[:name]}::#{rule[:variable]}}"
  end

  ############################################################
  # Definition of conditions:
  
  def self.condition_matches_all(value, params)
    return true
  end
    
  def self.condition_is?(value, params)
    value = separate_link_label(value)
    match = false
    params.each { |param| match ||= (value.to_s == param.to_s) }
    return match
  end
    
  def self.condition_is_not?(value, params)
    value = separate_link_label(value)
    match = true
    params.each { |param| match &&= (value.to_s != param.to_s) }
    return match
  end

  def self.condition_ends_with?(value, params)
    value = separate_link_label(value)
    match = false
    params.each { |param| match ||= (value.to_s.ends_with?(param.to_s)) }
    return match
  end

  def self.condition_not_ends_with?(value, params)
    value = separate_link_label(value)
    match = true
    params.each { |param| match &&= (!value.to_s.ends_with?(param.to_s)) }
    return match
  end

  def self.condition_starts_with?(value, params)
    value = separate_link_label(value)
    match = false
    params.each { |param| match ||= (value.to_s.starts_with?(param.to_s)) }
    return match
  end

  def self.condition_not_starts_with?(value, params)
    value = separate_link_label(value)
    match = true
    params.each { |param| match &&= (!value.to_s.starts_with?(param.to_s)) }
    return match
  end

  def self.condition_is_le?(value, params)
    value = separate_link_label(value)
    match = false
    params.each { |param| match ||= (value.to_i <= param.to_i) }
    return match
  end

  def self.condition_is_gt?(value, params)
    value = separate_link_label(value)
    match = false
    params.each { |param| match ||= (value.to_i > param.to_i) }
    return match
  end

  ############################################################
  # Definition of actions

  def self.action_replace(name, value, params)
    stripped_value = separate_link_label(value)
    new_value = (params[0] || stripped_value).to_s
    merge_link_label(value, stripped_value, new_value)
  end
  
  def self.action_remove_last_chars(name, value, params)
    stripped_value = separate_link_label(value)
    return value if params[0].to_i <= 0
    index = stripped_value.length - params[0].to_i - 1
    new_value = stripped_value[0..index]
    merge_link_label(value, stripped_value, new_value)
  end
  
  def self.action_remove_first_chars(name, value, params)
    stripped_value = separate_link_label(value)
    return value if params[0].to_i <= 0
    new_value = stripped_value[params[0].to_i..-1]
    merge_link_label(value, stripped_value, new_value)
  end
  
  def self.action_append(name, value, params)
    stripped_value = separate_link_label(value)
    new_value = stripped_value + params[0].to_s
    merge_link_label(value, stripped_value, new_value)
  end
  
  def self.action_prepend(name, value, params)
    stripped_value = separate_link_label(value)
    new_value = params[0].to_s + stripped_value
    merge_link_label(value, stripped_value, new_value)
  end
  
  def self.action_auto_pluralize(name, value, params)
    stripped_value = separate_link_label(value)
    new_value = pluralize(stripped_value, name)
    merge_link_label(value, stripped_value, new_value)
  end
  

  ############################################################
  # A rule matches if all conditions match
  # A rule with no conditions doesn't match
  
  def match?(value)
    return false if conditions.empty?

    conditions.each do |condition, params|
      return false unless
        self.class.send("condition_#{self.class::CONDITIONS[condition]}",
                        value, params)
    self.class.send("condition_matches_all", value, params)
    end
    
    return true
  end

  def self.rules_for(language, type=nil)

    return where(:locale => language).order(:type, :position) if type.nil?
    
    return [] unless $redis.sismember("otwtranslation_rules_for_#{language}", type)

    where(:locale => language,
          :type => "Otwtranslation::#{type.to_s.capitalize}Rule")
      .order(:position)
  end
  

  def display_type
    type.gsub(/Otwtranslation::(.*)Rule/, '\1').downcase
  end


  def self.separate_link_label(value)
    value = value.to_s
    begin
      value.match(/<a .*?>(.*?)<\/a>/)
    rescue NoMethodError
    end
    $1 || value
  end


  def self.merge_link_label(value, stripped_value, new_value)
    if value == stripped_value || !value.is_a?(String)
      return new_value
    else
      return value.gsub(/(<a .*?>)(.*?)(<\/a>)/, '\1' + new_value + '\3')
    end
  end
  

  def perform_actions(name, value)
    actions.each do |action, params|
      value = self.class.send("action_#{self.class::ACTIONS[action]}",
                                  name, value, params)
    end

    value.to_s
  end


  def self.apply_rule(language, content, variables)
    variable = content[:variable]
    value = variables[content[:variable].to_sym]
    
    return self.rule_to_label(content) if value.nil?
    
    rules_for(language, content[:name]).each do |rule|
      return rule.perform_actions(variable, value) if rule.match?(value)
    end
    
    return value.to_s
  end
    
  
  def self.apply_rules(label, language, variables={})
    applied = ""

    self.tokenize_label(label).each do |token, content|
      if token == :text
        applied += content
      else
        applied += apply_rule(language, content, variables)
      end
    end

    return applied
  end


  def self.matching_rules(label, language, variables={})
    rules = []

    self.tokenize_label(label).each do |token, content|
      if token != :text
        value = variables[content[:variable].to_sym]
        self.rules_for(language, content[:name]).each do |rule|
          if rule.match?(value)
            rules << rule
            break
          end
        end
      end
    end

    return rules
  end


  def self.rule_combinations(label, language)
    rules = []
    tokenize_label(label).each do |token, content|
      rules << self.rules_for(language, content[:name]) if token != :text
    end

    if rules.length > 0
      rules = rules[0].product(*rules[1..-1])
    end

    rules
  end

  def add_to_cache
    $redis.sadd("otwtranslation_rules_for_#{locale}", display_type)
  end

  # remove rule from redis and from all translations currently using it
  # (i.e. set translations to not approved and context-unaware)
  def clean_cache_and_translations
    $redis.srem("otwtranslation_rules_for_#{locale}", display_type)

    Otwtranslation::Translation.for_language(locale)
      .where("rules != '#{[].to_yaml}'").each do |translation|
      if translation.rules.include?(id)
        translation.approved = false
        translation.rules = []
        translation.save!
      end
    end
  end
  

end
