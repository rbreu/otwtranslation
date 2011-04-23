require 'polyglot'
require 'treetop'

Treetop.load(File.join(File.dirname(__FILE__), 'context_rules'))

class Otwtranslation::TokenisedLabel
  attr_accessor :label

  @@context_parser = ContextRulesParser.new

  def initialize(label, variables = {})
    @label = @@context_parser.parse(label).content
  end

  
  def apply_rules(variables={})
    label = ""
    @label.each do |token, content|
      if token == :text
        label += content
      else
        label += (variables[content[:variable].to_sym] || content[:variable]).to_s
      end
    end
    return label
  end


  def all_text?
    @label.length == 1 && @label[0][0] == :text
  end

end
