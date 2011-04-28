class Otwtranslation::ContextRule < ActiveRecord::Base

  include ActionView::Helpers::TextHelper
  
  serialize :definition
  serialize :operations

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
    "has more elements than" => "has_gt_elements?",
    "is lesser/equal than" => "is_le?",
    "is greater than" => "is_gt?"
  }

  @@ACTIONS = {
    "replace" => { :params => ["replacement"], :function => "replace" },
    "append" => { :params => ["suffix"], :function => "append" },
    "prepend" => { :params => ["prefix"], :function => "prepend" },
    "auto pluralize" => { :params => [], :function => "auto_pluralize" },
    "list replace" => { :params => ["words_connector",
                                    "two_words_connector",
                                    "last_word_connector"],
      :function => "list_replace" }
    }


  ############################################################
  # Definition of conditions:
  
  def self.condition_is?(value, param)
    value.to_s == param
  end

  def self.condition_is_not?(value, param)
    value.to_s != param
  end

  def self.condition_ends_with?(value, param)
    value.to_s.ends_with?(param)
  end

  def self.condition_not_ends_with?(value, param)
    !value.to_s.ends_with?(param)
  end

  def self.condition_starts_with?(value, param)
    value.to_s.starts_with?(param)
  end

  def self.condition_not_starts_with?(value, param)
    !value.to_s.starts_with?(param)
  end

  def self.condition_has_le_elements?(value, param)
     value.length <= param.to_i
  end

  def self.condition_has_gt_elements?(value, param)
     value.length > param.to_i
  end

  def self.condition_is_le?(value, param)
    value <= param.to_i
  end

  def self.condition_is_gt?(value, param)
    value > param.to_i 
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
  
end
