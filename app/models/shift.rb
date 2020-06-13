class Shift < ApplicationRecord
  belongs_to :user

  def self.current
    shifts = []
    User.all.each do |user|
      s = user.current_shift
      if s
        shifts << s 
      end
    end
    return shifts
  end

  def self.over_dates(start, ending)
    shifts = []
    Shift.all.each do |shift|
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
end
