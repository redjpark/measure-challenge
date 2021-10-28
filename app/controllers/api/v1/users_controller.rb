class Api::V1::UsersController < ApplicationController

  before_action :set_user, only: %i/show update destroy/

  def index
    @users = User.all
    json_response(@users)
  end

  def show
    json_response(@user)
  end

  def create
    @user = User.create!(user_params)
    json_response(@user, :created)
  end

  def update
    @user.update(user_params)
    head :no_content
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :phone_number)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
