class ShiftsController < ApplicationController
  def index
    # FIXME: should take optional start, end date params
    render :json => Shift.sorted, :include => {:user => {:only => [:first_name, :last_name]}}
  end

  def current
    render :json => Shift.current, :include => {:user => {:only => [:first_name, :last_name]}}
  end
end