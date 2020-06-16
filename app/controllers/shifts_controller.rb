class ShiftsController < ApplicationController
  def index
    # FIXME: should take optional start, end date params
    render :json => Shift.sorted, :include => {:user => {:only => [:first_name, :last_name]}}
  end

  def current
    render :json => Shift.current, :include => {:user => {:only => [:first_name, :last_name]}}
  end

  def create
    shift = Shift.create({
      start: Time.now,
      end: params[:end],
      user_id: params[:user_id]
    })
    render json: shift
  end

  def update
    shift = Shift.find(params[:id])
    shift.update({
      start: params[:start],
      end: params[:end],
    })
    render json: shift
  end


end
