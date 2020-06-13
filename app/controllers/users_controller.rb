class UsersController < ApplicationController

  # todo: need to authorize most calls
  def index
    render json: User.all
  end

  def shifts
    # FIXME: should take in optional start/end params
    user = User.find(params[:id])
    render json: {shifts: user.shifts}
  end

  def punch
    user = User.find(params[:id])
    # todo: consider passing in a datetime param?
    render json: user.punch(Datetime.current)
  end

  def current
    user = User.find(params[:id])
    render json: user.current_shift
  end

  def wages_last_30
    user = User.find(params[:id])
    render json: {amount: user.wages_last_30_days}
  end

  def wages_pay_period
    user = User.find(params[:id])
    render json: {amount: user.wages_since_month_start}
  end

end