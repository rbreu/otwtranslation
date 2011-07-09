class Otwtranslation::AssignmentPartsController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only
  before_filter :nonactivated_only

  def nonactivated_only
    @part = Otwtranslation::AssignmentPart.find(params[:id])
    
    if @part.assignment.activated
      flash[:error] = "You can't edit an activated assignment."
      redirect_to otwtranslation_assignment_path(@part.assignment)
      return false
    else
      return true
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

  
end

