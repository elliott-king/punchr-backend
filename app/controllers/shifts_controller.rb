class ShiftsController < ApplicationController
  def index
    # FIXME: should take optional start, end date params
    render json: Shift.all
  end

  def current
    render json: Shift.current
  end
end