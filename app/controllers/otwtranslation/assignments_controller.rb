class Otwtranslation::AssignmentsController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only
  before_filter :nonactivated_only, :only => [:edit, :update]

  def nonactivated_only
    @assignment = Otwtranslation::Assignment.find(params[:id])
    
    if @assignment.activated
      flash[:error] = "You can't edit an activated assignment."
      redirect_to otwtranslation_assignment_path(@assignment)
      return false
    else
      return true
    end
  end

  
  def new
    @source_controller_action = params[:controller_action]
    @assignment = Otwtranslation::Assignment.new()
  end

  def index
    @assignments = Otwtranslation::Assignment
      .where(:language_short => otwtranslation_language).paginate(:page => params[:page])
  end

  def show
    @assignment = Otwtranslation::Assignment.find(params[:id])
  end

  
  def confirm_destroy
    respond_to do |format|
      format.html do
        @assignment = Otwtranslation::Assignment.find(params[:id])
      end
      format.js do
        @assignment_id = params[:id]
      end
    end
  end

  
  def destroy
    @assignment = Otwtranslation::Assignment.find(params[:id])
    @assignment.destroy
    respond_to do |format|
      format.html do
        redirect_to otwtranslation_assignments_path
      end
      format.js do
      end
    end
  end


  def create

    @assignment = Otwtranslation::Assignment.new(:description => params[:description],
                                                 :language_short => otwtranslation_language)

    unless params[:source_controller_action].blank?
      source = Otwtranslation::Source
        .find_by_controller_action(params[:source_controller_action])
     @assignment.errors[:source] = "Unknown source" if source.nil?
    end

    pseuds = Pseud.parse_bylines(params[:assignees_names])
    unless pseuds[:ambiguous_pseuds].blank? && pseuds[:invalid_pseuds].blank?
      @assignment.errors[:assignees] << "Invalid/ambiguous users."
    end
    #names = Otwtranslation::ParameterParser.tokenize(params[:assignees_names])
    @assignment.set_assignees(pseuds[:pseuds])
    @assignment.source = source
    @assignment.save if @assignment.errors.blank?
    
    if @assignment.errors.blank?
      redirect_to otwtranslation_assignment_path(@assignment)
    else
      @source_controller_action = params[:source_controller_action]
      @assignees_names = params[:assignees_names]
      msg = 'There was a problem with the assignment:' +
        prettify_error_messages(@assignment)
      flash[:error] = msg.html_safe
      render(:action => 'new') && return 
    end
  end


  def edit
    if @assignment.source.nil?
      @source_controller_action = ""
    else
      @source_controller_action = @assignment.source.controller_action
    end

    respond_to do |format|
      format.html
      format.js
    end
    
  end


  def update
    unless params[:source_controller_action].blank?
      source = Otwtranslation::Source
        .find_by_controller_action(params[:source_controller_action])
     @assignment.errors[:source] = "Unknown source" if source.nil?
    end

    @assignment.source = source
    @assignment.description = params[:description]
    @assignment.save if @assignment.errors.blank?
    
    if @assignment.errors.blank?
      respond_to do |format|
        format.html do
          redirect_to otwtranslation_assignment_path(@assignment)
        end
        format.js { render "edit_success" }
      end
    else
      @source_controller_action = params[:source_controller_action]
      @assignees_names = params[:assignees_names]
      msg = 'There was a problem with the assignment:' +
        prettify_error_messages(@assignment)
      flash[:error] = msg.html_safe
      respond_to do |format|
        format.html { render(:action => 'edit') }
        format.js { render "edit_fail" }
      end
    end
  end


  def activate
    @assignment = Otwtranslation::Assignment.find(params[:id])
    @assignment.activate

    unless @assignment.errors.blank?
      msg = 'There was a problem with the assignment:' +
        prettify_error_messages(@assignment)
    end

    respond_to do |format|
      format.html do
        redirect_to :back
      end
      format.js { render "activate" }
    end
  end


  def complete_part
    @assignment = Otwtranslation::Assignment.find(params[:id])
    @part = @assignment.parts.active
    
    unless @assignment.users_turn?(current_user)
      flash[:error] = "You can only complete active parts that are assigned to you."
      redirect_to otwtranslation_assignment_path(@assignment)
    end
  end

end

