class UsersController < ApplicationController
  # before_action :authorize_request, only: [:index, :get, whatever...]

  # todo: need to authorize most calls
  def index
    render json: User.all.as_json(except: [:password_digest])
  end

  def shifts
    # FIXME: should take in optional start/end params
    user = User.find(params[:id])
    render json: user.shifts, :include => {:user => {:only => [:first_name, :last_name]}}
  end

  def punch
    user = User.find(params[:id])
    # todo: consider passing in a datetime param?
    render json: user.punch(Datetime.current)
  end

  def current
    user = User.find(params[:id])
    render json: user.current_shift, :include => {:user => {:only => [:first_name, :last_name]}}
  end

  def wages_last_30
    user = User.find(params[:id])
    render json: {amount: user.wages_last_30_days}
  end

  def wages_pay_period
    user = User.find(params[:id])
    render json: {amount: user.wages_since_month_start}
  end

  def create
    # TODO: this doesn't check for email duplicates
    user = User.create({
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      phone: params[:phone],
      pin: params[:pin],
      password: params[:password]
    })

    render user.as_json(except: [:password_digest])
  end

end
