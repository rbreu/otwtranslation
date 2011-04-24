require 'polyglot'
require 'treetop'

Treetop.load(File.join(File.dirname(__FILE__), 'context_rules'))

module Otwtranslation::Tokenisable

  @@context_parser = ContextRulesParser.new
  attr_accessor :tokenised_label

  def tokenise_label()
    if @tokenised_label.nil?
      @tokenised_label = @@context_parser.parse(label).content
    end
  end

  
  def apply_rules(variables={})
    tokenise_label()
    applied = ""
    @tokenised_label.each do |token, content|
      if token == :text
        applied += content
      else
        applied += (variables[content[:variable].to_sym] || content[:variable]).to_s
      end
    end
    return applied
  end


  def all_text?
    tokenise_label()
    @tokenised_label.length == 1 && @tokenised_label[0][0] == :text
  end

end
