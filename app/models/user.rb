require 'bcrypt'
require 'date'

class User < ApplicationRecord
  has_secure_password
  has_many :shifts, -> {order 'start asc'}

  def current_shift
    last = self.shifts.last
    if !last || last.end 
      return false
    end
    return last
  end

  def over_dates(start, ending)
    shifts = []
    self.shifts.each do |shift|
      if shift.end
        start_in_range = (shift.start < ending && shift.start > start)
        end_in_range = (shift.end < ending && shift.end > start)
        if start_in_range || end_in_range
          shifts << shift
        end
      end
    end
    return shifts
  end

  # Takes a datetime and updates the user's shifts. Returns the shift
  # todo: consider some error checking => end > start?
  def punch(dt = DateTime.current)
    last_shift = self.shifts.last
    if !last_shift || last_shift.end
      return Shift.create!(start: dt, user: self)
    else
      last_shift.update!(end: dt)
      return last_shift
    end
  end
end
