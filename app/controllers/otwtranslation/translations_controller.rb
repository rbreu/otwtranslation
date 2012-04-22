class Otwtranslation::TranslationsController < ApplicationController
  include Otwtranslation::CommonMethods
  include OtwtranslationHelper
  
  before_filter :otwtranslation_only

  def new
    @translation = Otwtranslation::Translation.new
    @translation.phrase_key = params[:id]
    
    respond_to do |format|
      format.html do
        @phrase = Otwtranslation::Phrase.find_by_key(params[:id])
        @existing_translations = @phrase.translations.for_language(otwtranslation_language)
        @sources = @phrase.sources.paginate(:page => params[:page], :per_page => 10)

      end
        
      format.js
    end
  end


  def edit
    @translation = Otwtranslation::Translation.find(params[:id])
    
    respond_to do |format|
      format.html do
        @phrase = Otwtranslation::Phrase.find_by_key(@translation.phrase_key)
        @existing_translations = @phrase.translations.for_language(otwtranslation_language)
        @sources = @phrase.sources.paginate(:page => params[:page], :per_page => 10)
        render 'edit'
      end
        
      format.js
    end
  end


  def create
    msg = ""
    @phrase_key = params[:id]
    @translations = []
    
    if params[:commit].downcase == "create context-aware translations"
      phrase = Otwtranslation::Phrase.find_from_cache_or_db(params[:id])
      combinations = Otwtranslation::ContextRule
        .rule_combinations(phrase.label, otwtranslation_language)

      combinations.each do |combination|
        translation = Otwtranslation::Translation.new()
        translation.label = phrase.label
        translation.locale = otwtranslation_language
        translation.phrase_key = params[:id]
        translation.rules = combination.map{|r| r.id}
        translation.last_editor = current_user
        translation.edited_at = Time.now
        if translation.save
          @translations << translation
        else
          msg += 'There was a problem saving the translation:' +
            prettify_error_messages(translation) 
        end
      end
      flash[:notice] = "Refresh the page to see the proper effect of context-aware translations."

    else # create a non-context-specific translation
      translation = Otwtranslation::Translation.new
      translation.label = params[:otwtranslation_translation][:label]
      translation.phrase_key = params[:id]
      translation.locale = otwtranslation_language
      translation.last_editor = current_user
      translation.edited_at = Time.now
    
      if translation.save
        @translations << translation
      else
        msg += 'There was a problem saving the translation:' +
          prettify_error_messages(translation) 
      end
    end

    if msg.blank?
      respond_to do |format|
        format.html { redirect_to otwtranslation_phrase_path(@phrase_key) }
        format.js { render 'create_success' }
      end
    else
      flash[:error] = msg.html_safe
      respond_to do |format|
        format.html { redirect_to otwtranslation_new_translation_path(@phrase_key)}
        format.js { render 'create_fail' }
      end
    end
  end

  
  def approve
    @translation = Otwtranslation::Translation.find(params[:id])
    @translation.approved = true
    
    unless @translation.save
      msg = 'There was a problem saving the translation:' +
        prettify_error_messages(@translation) 
      flash[:error] = msg.html_safe
      @translation.approved = false
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render 'dis_approve' }
    end
      
  end


  def confirm_disapprove
    respond_to do |format|
      format.html do
        @translation = Otwtranslation::Translation.find(params[:id])
      end
      format.js do
        @translation_id = params[:id]
      end
    end
  end


  def disapprove
    @translation = Otwtranslation::Translation.find(params[:id])
    @translation.approved = false
    
    unless @translation.save
      msg = 'There was a problem saving the translation:' +
        prettify_error_messages(@translation) 
      flash[:error] = msg.html_safe
      @translation.approved = true
    end

    respond_to do |format|
      format.html { redirect_to otwtranslation_phrase_path(@translation.phrase_key) }
      format.js { render 'dis_approve' }

    end
  end

  
  def confirm_destroy
    respond_to do |format|
      format.html do
        @translation = Otwtranslation::Translation.find(params[:id])
      end
      format.js do
        @translation_id = params[:id]
      end
    end
  end


  def destroy
    @translation = Otwtranslation::Translation.find(params[:id])
    @translation.destroy
    redirect_to otwtranslation_phrase_path(@translation.phrase_key)
  end


  def show
    @translation = Otwtranslation::Translation.find(params[:id])
    @phrase = Otwtranslation::Phrase.find_by_key(@translation.phrase_key)
    @sources = @phrase.sources.paginate(:page => params[:page], :per_page => 10)
  end
  

  def update
    @translation = Otwtranslation::Translation.find(params[:id])
    @translation.label = params[:otwtranslation_translation][:label]
    @translation.last_editor = current_user
    @translation.edited_at = Time.now

    if @translation.save
      respond_to do |format|
        format.html { redirect_to otwtranslation_translation_path(@translation) }
        format.js { render 'edit_success' }
      end
    else
      msg = 'There was a problem saving the translation:' +
        prettify_error_messages(@translation) 
      flash[:error] = msg.html_safe
      respond_to do |format|
        format.html { redirect_to otwtranslation_edit_translation_path(params[:id])}
        format.js { render 'edit_fail' }
      end
    end
  end
  

  def vote
    if params[:commit].downcase == "vote up"
      Otwtranslation::Vote.vote(params[:id], current_user, :up)
    elsif params[:commit].downcase == "vote down"
      Otwtranslation::Vote.vote(params[:id], current_user, :down)
    else
      raise ArgumentError, "Unknown param for voting."
    end
      
    respond_to do |format|
      format.html { redirect_to :back }
      format.js do
        @translation = Otwtranslation::Translation.find(params[:id])
        render 'vote'
      end
    end
  end

end

