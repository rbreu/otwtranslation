class Otwtranslation::AssignmentPartsController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only

  def confirm_destroy
    respond_to do |format|
      format.html do
        @part = Otwtranslation::AssignmentPart.find(params[:id])
      end
      format.js do
        @part_id = params[:id]
      end
    end
  end

  
  def destroy
    @part = Otwtranslation::AssignmentPart.find(params[:id])
    @part.destroy
    redirect_to otwtranslation_assignment_path(@part.assignment)
  end


end

