class Shift < ApplicationRecord
  belongs_to :user

  def self.sorted
    # Apparently Postgres puts NULLs at end of list, so I don't need to implement my own sort fn.
    Shift.order(:end, :start)
  end

  def self.current
    shifts = []
    User.all.each do |user|
      s = user.current_shift
      if s
        shifts << s 
      end
    end
    return shifts.sort_by{|shift| shift.start}
  end

  def self.over_dates(start, ending)
    shifts = []
    Shift.sorted.each do |shift|
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
