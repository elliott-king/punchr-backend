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

  # calc wages owed based on a start datetime
  def wages_over_dates(dt_from = DateTime.new(2000,1,1,1,0,15), dt_to = DateTime.current)
    dt_from = dt_from.in_time_zone('UTC')
    dt_to = dt_to.in_time_zone('UTC')
    shifts = self.shifts.reverse
    hours = 0
    shifts.each do |shift|
      # If current shift is incomplete, ignore it
      if !shift.end
        next
      end
      if shift.start > dt_to
        next
      end
      if shift.end < dt_from 
        return hours * self.hourly_wage
      end
      if shift.end > dt_to 
        if shift.start < dt_from
          puts('shift that starts before dt_from and after dt_to')
          hours = (dt_to - dt_from) / 1.hours
          return hours * self.hourly_wage
        end
        hours += (dt_to - shift.start.to_datetime) / 1.hours
      elsif dt_from > shift.start
        hours += (shift.end - dt_from) / 1.hours
        return hours * self.hourly_wage
      else
        hours += (shift.end - shift.start) / 1.hours
      end
    end
    return hours * self.hourly_wage
  end

  def wages_last_30_days
    return wages_over_dates(30.days.ago)
  end

  def wages_since_month_start
    return wages_over_dates(DateTime.current.at_beginning_of_month)
  end

end
