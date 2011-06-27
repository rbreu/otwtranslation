require 'polyglot'
require 'treetop'

Treetop.load(File.join(File.dirname(__FILE__), 'parameter_rules'))

class Otwtranslation::ParameterParser < ActiveRecord::Base
  @@parameter_parser = ParameterRulesParser.new

  def self.tokenize(params)
    @@parameter_parser.parse(params.strip).content
  end

  def self.stringify(params, delimiter=", ")
    quoted = []

    params.each do |param|
      param = param.to_s
      if param.include?(",") || param.end_with?(" ") || param.start_with?(" ")
        quoted << "\"#{param}\""
      else
        quoted << param
      end
    end
    
    quoted.join(delimiter)
  end
  
end
