require 'polyglot'
require 'treetop'

Treetop.load(File.join(File.dirname(__FILE__), 'parameter_rules'))

class Otwtranslation::ParameterParser < ActiveRecord::Base
  @@parameter_parser = ParameterRulesParser.new

  def self.tokenize(params)
    @@parameter_parser.parse(params.strip).content
  end


end
