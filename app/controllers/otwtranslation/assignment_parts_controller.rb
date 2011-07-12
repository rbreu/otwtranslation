class Otwtranslation::AssignmentPartsController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only
  before_filter :nonactivated_only_part, :only => [:confirm_destroy, :destroy,
                                                   :move_up, :move_down]
  before_filter :nonactivated_only_assignment, :only => [:new, :create]

  def nonactivated_only_part
    @part = Otwtranslation::AssignmentPart.find(params[:id])
    
    if @part.assignment.activated
      flash[:error] = "You can't edit an activated assignment."
      redirect_to otwtranslation_assignment_path(@part.assignment)
      return false
    else
      return true
    end
  end

  def nonactivated_only_assignment
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
    @part = Otwtranslation::AssignmentPart.new(:assignment => @assignment)
  end

  def create
    @part = Otwtranslation::AssignmentPart.new(:assignment => @assignment)
    user = User.find_by_login(params[:login])
    if user.nil?
      @part.errors[:login] = "No such user: #{params[:login]}"
    else
      @part.assignee = user
      @part.save
    end
    
    if @part.errors.blank?
      respond_to do |format|
        format.html do
          redirect_to otwtranslation_assignment_path(@assignment)
        end
        format.js { render "create_success" }
      end
    else
      msg = 'There was a problem with the assignee:' +
        prettify_error_messages(@part)
      flash[:error] = msg.html_safe
      
      respond_to do |format|
        format.html { render(:action => 'new') }
        format.js { render "create_fail" }
      end
    end
  end

   
  def confirm_destroy
    respond_to do |format|
      format.html do
      end
      format.js do
        @part_id = params[:id]
      end
    end
  end

  
  def destroy
    @part.destroy
    redirect_to otwtranslation_assignment_path(@part.assignment)
  end


  def move_up
    @part.move_higher
    redirect_to otwtranslation_assignment_path(@part.assignment)
  end

  
  def move_down
    @part.move_lower
    redirect_to otwtranslation_assignment_path(@part.assignment)
  end

  
  def complete
    @part = Otwtranslation::AssignmentPart.find(params[:id])
    @assignment = @part.assignment
      
    if @assignment.users_turn?(current_user)
      @part.notes = params[:otwtranslation_assignment_part][:notes]
      @part.status = :completed
      if @part.save
        next_part = @part.lower_item
        next_part.activate unless next_part.nil?
        redirect_to otwtranslation_assignment_path(@assignment)
      else
        msg = 'There was a problem with the assignment part:' +
          prettify_error_messages(@part)
        flash[:error] = msg.html_safe
        render(:template => "otwtranslation/assignment/complete_part")
      end  
      
    else
      flash[:error] = "You can only complete active parts that are assigned to you."
      redirect_to otwtranslation_assignment_path(@part.assignment)
    end
  end
  
end

