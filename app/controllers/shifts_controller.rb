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
    render :json => Shift.over_dates(start_date, end_date), :include => {:user => {:only => [:first_name, :last_name, :is_manager, :pin]}}
  end

  def current
    render :json => Shift.current, :include => {:user => {:only => [:first_name, :last_name, :is_manager, :pin]}}
  end

  def create
    shift = Shift.create!({
      start: params[:start] ? DateTime.parse(params[:start]) : Time.now,
      end: params[:end] ? DateTime.parse(params[:end]) : nil,
      user_id: params[:user_id]
    })
    render json: shift, :include => {:user =>  {:only => [:first_name, :last_name, :is_manager, :pin]}}
  end

  def update
    shift = Shift.find(params[:id])
    if (params[:start])
      shift.update!({start: params[:start]})
    end
    if params[:end]
      if params[:end] == 'no end'
        shift.update({end: nil})
      else
        shift.update({end: params[:end]})
      end
    end
    render json: shift, :include => {:user => {:only => [:first_name, :last_name, :is_manager, :pin]}}
  end


end
