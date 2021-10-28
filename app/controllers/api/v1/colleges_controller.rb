class Api::V1::CollegesController < ApplicationController

  before_action :set_college, only: %i/show update destroy/

  def index
    @colleges = College.all
    json_response(@colleges)
  end

  def show
    json_response(@college)
  end

  def create
    @college = College.create!(college_params)
    json_response(@college, :created)
  end

  def update
    @college.update(college_params)
    head :created
  end

  def destroy
    @college.destroy
    head :no_content
  end

  private

  def college_params
    params.permit(:name)
  end

  def set_college
    @college = College.find(params[:id])
  end

end
