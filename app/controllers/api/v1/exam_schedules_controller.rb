class Api::V1::ExamSchedulesController < ApplicationController

  before_action :set_user, only: %i/get_schedule/
  before_action :check_for_required_params, only: %i/create_schedule/

  def create_schedule
    @user = User.create_if_not_found(*schedule_params.slice(:first_name, :last_name, :phone_number).values)
    @college = College.find(params[:college_id])
    if @college.valid_exam?(params[:exam_id])
      @exam = Exam.find(params[:exam_id])
    else
      return json_response({message: 'exam not found in college'}, :bad_request)
    end
    unless @exam.valid_window?(params[:start_time])
      return json_response({message: 'start_time is not within the Exam time window'}, :bad_request)
    end
    @user.add_exam(@exam)
    json_response(@user.attributes.slice('first_name', 'last_name', 'phone_number').merge({college_id: @college.id,
                               exam_id: @exam.id,
                               start_time: @exam.exam_window.start_time}),
                  :created)
  end

  def get_schedule
    json_response(@user.exams, :ok)
  end

  private

  def check_params
    schedule_params.keys == %i/first_name, last_name, phone_number,
                  college_id, exam_id, start_time/
  end

  def check_for_required_params
    unless schedule_params.keys == %w/first_name last_name phone_number college_id exam_id start_time/
      raise ArgumentError.new('missing arguments')
    end
  end

  def schedule_params
    params.permit(:first_name, :last_name, :phone_number,
                  :college_id, :exam_id, :start_time)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

end