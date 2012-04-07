require 'erb'

class Otwtranslation::MailsController < ApplicationController
  include Otwtranslation::CommonMethods
  include OtwtranslationHelper
  extend ActionView::Helpers::UrlHelper
 
  before_filter :otwtranslation_only

  def index
    @paths = OtwtranslationConfig.mail_paths.paginate(:page => params[:page])
  end

  def show
    view_path = OtwtranslationConfig.mail_paths[params[:id].to_i]
    @text = dummy_render(view_path)
  end

  private
  
  def method_missing(symbol, *arguments, &block)
    #if respond_to?(symbol) #|| !symbol.to_s.start_with?("__")
    #  return super(symbol, *arguments, &block)
    #else
    return Otwtranslation::Dummy.new
  end

  def dummy_render(path)
    raw = File.open(path).read
    
    # We can't just render this since we can't provide the needed
    # instance variables, and instead of triggering whiny nils, we
    # want some silent dummy objects. Problem: There's no way to hook
    # into Ruby's way of accessing instance variables. 
    # (Cf. http://www.ruby-forum.com/topic/160989 )
    #
    # Below follows an ugly hack to 'convert' instance variables (@foo
    # etc.) in the original templates into instance methods (__foo
    # etc.) because then we can hook into method_missing.
    #
    # Since gsub doesn't find overlapping matches and there might be
    # more than onve instance variable per code tag, repeat the
    # substituting until we replaced all instance variables
    while true do
      raw_new = raw.gsub(/(<%.*?)(@)(.*?%>)/m, '\1__\3')
      break if raw_new == raw
      raw = raw_new
    end

    # remove rendering of partials (they'll be listed on their own)
    raw.gsub!(/<%=\s.*?render.*?%>/, "")
    
    ERB.new(raw).result(binding).html_safe
  end
end

