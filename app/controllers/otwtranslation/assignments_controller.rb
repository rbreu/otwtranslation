class Otwtranslation::AssignmentsController < ApplicationController
  include Otwtranslation::CommonMethods
  before_filter :otwtranslation_only


  def index
    @assignments = Otwtranslation::Assignment.all
  end

  def show
    @assignment = Otwtranslation::Assignment.find(params[:id])
  end

end

