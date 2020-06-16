require 'date'

class ShiftsController < ApplicationController
  def index
    start_date = DateTime.new(2000,1,30,7,0,15)
    end_date = DateTime.now
    if params[:start]
      start_date = DateTime.parse(params[:start])
    end
    if params[:end]
      end_date = DateTime.parse(params[:end])
    end
    render :json => Shift.over_dates(start_date, end_date), :include => {:user => {:only => [:first_name, :last_name, :is_manager]}}
  end

  def current
    render :json => Shift.current, :include => {:user => {:only => [:first_name, :last_name, :is_manager]}}
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
