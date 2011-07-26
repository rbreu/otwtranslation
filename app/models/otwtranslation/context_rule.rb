require 'polyglot'
require 'treetop'

Treetop.load(File.join(File.dirname(__FILE__), 'context_rules'))

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
  # [["append", ["s"]]]
  # A rule if all condition matches. Rules without conditions always match.
  # Actions are processed in order.
  serialize :actions

  acts_as_list :scope => 'language_short = \'#{language_short}\' AND type = \'#{type}\''

  validates_presence_of :language_short

  after_destroy :clean_cache_and_translations
  after_save :add_to_cache

  
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
      "is lesser/equal than" => "is_le?",
      "is greater than" => "is_gt?",
      "matches all" => "matches_all",
  }


  ACTIONS =  {
      "replace" => "replace",
      "replace end" => "replace_end",
      "replace beginning" => "replace_beginning",
      "append" => "append",
      "prepend" => "prepend",
      "auto pluralize" => "auto_pluralize"
  }


  after_initialize :init_actions_conditions

  def init_actions_conditions
    self.conditions ||= []
    self.actions ||= []
  end

  ############################################################

  def self.conditions
    self::CONDITIONS.keys
  end
  
  def self.actions
    self::ACTIONS.keys
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
    params.each { |param| match ||= (value.to_s == param) }
    return match
  end
    
  def self.condition_is_not?(value, params)
    value = separate_link_label(value)
    match = true
    params.each { |param| match &&= (value.to_s != param) }
    return match
  end

  def self.condition_ends_with?(value, params)
    value = separate_link_label(value)
    match = false
    params.each { |param| match ||= (value.to_s.ends_with?(param)) }
    return match
  end

  def self.condition_not_ends_with?(value, params)
    value = separate_link_label(value)
    match = true
    params.each { |param| match &&= (!value.to_s.ends_with?(param)) }
    return match
  end

  def self.condition_starts_with?(value, params)
    value = separate_link_label(value)
    match = false
    params.each { |param| match ||= (value.to_s.starts_with?(param)) }
    return match
  end

  def self.condition_not_starts_with?(value, params)
    value = separate_link_label(value)
    match = true
    params.each { |param| match &&= (!value.to_s.starts_with?(param)) }
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
  # Definition of actions:
  # value may not be a string, params are always strings

  def self.action_replace(name, value, params)
    stripped_value = separate_link_label(value).to_s
    new_value = params[0] || stripped_value
    merge_link_label(value, stripped_value, new_value)
  end
  
  def self.action_replace_end(name, value, params)
    stripped_value = separate_link_label(value).to_s
    number = params[0].to_i
    number = [stripped_value.length - params[0].to_i, params[0].to_i].min
    
    new_value = stripped_value[0..number-1] + ( params[1] || stripped_value[number..-1] )
    merge_link_label(value, stripped_value, new_value)
  end
  
  def self.action_replace_beginning(name, value, params)
    stripped_value = separate_link_label(value).to_s
    number = params[0].to_i
    
    new_value = ( params[1] || stripped_value[0..number-1] ) + stripped_value[number..-1]
    
    merge_link_label(value, stripped_value, new_value)
  end
  
  def self.action_append(name, value, params)
    stripped_value = separate_link_label(value).to_s
    new_value = stripped_value + (params[0] || stripped_value)
    merge_link_label(value, stripped_value, new_value)
  end
  
  def self.action_prepend(name, value, params)
    stripped_value = separate_link_label(value).to_s
    new_value = (params[0] || stripped_value) + stripped_value
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

    return where(:language_short => language).order(:type, :position) if type.nil?
    
    return [] unless $redis.sismember("otwtranslation_rules_for_#{language}", type)

    where(:language_short => language,
          :type => "Otwtranslation::#{type.to_s.capitalize}Rule")
      .order(:position)
  end
  

  def display_type
    type.gsub(/Otwtranslation::(.*)Rule/, '\1').downcase
  end


  def self.separate_link_label(value)
    begin
      value.match(/<a .*?>(.*?)<\/a>/)
    rescue NoMethodError
    end
    $1 || value
  end


  def self.merge_link_label(value, stripped_value, new_value)
    if value == stripped_value
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
    $redis.sadd("otwtranslation_rules_for_#{language_short}", display_type)
  end

  # remove rule from redis and from all translations currently using it
  # (i.e. set translations to not approved and context-unaware)
  def clean_cache_and_translations
    $redis.srem("otwtranslation_rules_for_#{language_short}", display_type)

    Otwtranslation::Translation.for_language(language_short)
      .where("rules != '#{[].to_yaml}'").each do |translation|
      if translation.rules.include?(id)
        translation.approved = false
        translation.rules = []
        translation.save!
      end
    end
  end
  

end
