require 'erb'

class Otwtranslation::MailsController < ApplicationController
  include Otwtranslation::CommonMethods
  include OtwtranslationHelper

  before_filter :otwtranslation_only

  def index
    view = "otwtranslation/assignment_mailer/assignment_notification"
    render view
    
    #erb = ERB.new(File.open("#{RAILS_ROOT}/../app/views/#{view}.html.erb").read)
    #b = binding
    #p b.methods
    #p instance_variable_names
    #p instance_values
    #html = erb.result(b)
  end

  # http://www.ruby-forum.com/topic/160989
  # :-(
  
  def instance_variable_get(symbol)
    p "===="
    p symbol
    value = super(symbol)
    if value.nil?
      p "nil!"
    end
    p "===="

    return value
      
  end
  
end

