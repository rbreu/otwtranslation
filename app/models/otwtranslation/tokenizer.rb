require 'polyglot'
require 'treetop'

Treetop.load(File.join(File.dirname(__FILE__), 'context_rules'))

module Otwtranslation::Tokenizer

  @@context_parser = ContextRulesParser.new

  def self.tokenize_label(label)
    @@context_parser.parse(label).content
  end

  
  def self.all_text_or_data?(label)
    tokenize_label(label).each do |token, content|
      return false if token != :text && content[:name] != "data"
    end
    return true
  end

  def self.rule_to_s(rule)
    "{#{rule[:name]}::#{rule[:variable]}}"
  end

end
