class Otwtranslation::AssignmentsController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only

  def new
    @assignment = Otwtranslation::Assignment.new(:source => params[:source_id])
  end

  def index
    @assignments = Otwtranslation::Assignment.all
  end

  def show
    @assignment = Otwtranslation::Assignment.find(params[:id])
  end

  def create

    @assignment = Otwtranslation::Assignment.new(:description => params[:description])

    unless params[:source_controller_action].blank?
      source = Otwtranslation::Source
        .find_by_controller_action(params[:source_controller_action])
     @assignment.errors[:source] = "Unknown source" if source.nil?
    end
    
    names = Otwtranslation::ParameterParser.tokenize(params[:assignees_names])
    @assignment.set_assignees(names)
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
end

