require 'rails_helper'

RSpec.describe User, type: :model do

  before(:each) do
    @user = User.create!(first_name: "Elliott", last_name: "King", email: "something1@somewhere.com", phone: "8675309", pin: 7777, password: "elliott", hourly_wage: 10.00)
  end

  context 'handling user shifts: ' do
    it 'returns current shift' do 
      start_time = DateTime.new(2020,5,31,7,0,15)
      Shift.create!(start: start_time, user: @user)
      expect(@user.current_shift).to eq(Shift.last)
    end
    it 'returns false if user is off shift' do
      start_time = DateTime.new(2020,5,30,7,0,15)
      end_time = DateTime.new(2020,5,30,15,3,26)
      Shift.create!(start: start_time, end: end_time, user: @user)
      expect(@user.current_shift).to eq(false)
    end
    it 'returns false if user has no shifts' do
      expect(@user.current_shift).to eq(false)
    end
  end

  context 'handling punching' do
    it 'creates new shift if user has no shifts' do
      @user.punch
      expect(@user.shifts.count).to eq(1)
      shift = @user.shifts.last
      expect(shift.start).to_not be_nil
      expect(shift.end).to be_nil
    end
    it 'creates new shift if user is off shift' do
      start_time = DateTime.new(2020,5,30,7,0,15)
      end_time = DateTime.new(2020,5,30,15,3,26)
      Shift.create!(start: start_time, end: end_time, user: @user)
      @user.punch
      expect(@user.shifts.count).to eq(2)
      shift = @user.shifts.last
      expect(shift.start).to_not be_nil
      expect(shift.end).to be_nil
    end
    # todo: consider checking the time
    it 'returns last shift and closes if user on shift' do
      start_time = DateTime.new(2020,5,31,7,0,15)
      s = Shift.create!(start: start_time, user: @user)
      @user.punch 
      shift = @user.shifts.last
      expect(shift.start).to eq(start_time)
      expect(shift.end).to_not be_nil      
    end
    it 'takes in a datetime' do
      time = DateTime.new(2020,5,31,7,0,15)
      @user.punch(time)
      expect(@user.shifts.last.start).to eq(time)
    end
  end

  context 'identifying shifts within date ranges' do
    before(:each) do

      start_time = DateTime.new(2020,5,29,9,0,15)
      end_time = DateTime.new(2020,5,29,17,0,26)
      @s1 = Shift.create!(start: start_time, end: end_time, user: @user)

      start_time = DateTime.new(2020,5,30,7,0,15)
      end_time = DateTime.new(2020,5,30,15,3,26)
      @s2 = Shift.create!(start: start_time, end: end_time, user: @user)

      start_time = DateTime.new(2020,5,31,7,0,15)
      end_time = DateTime.new(2020,5,31,16,0,15)
      @s3 = Shift.create!(start: start_time, end: end_time, user: @user)
    end

    it 'works with one' do
      s = DateTime.new(2020,5,31,0,0,15)
      e = DateTime.new(2020,6,3,0,0,15)
      shifts = @user.over_dates(s, e)
      expect(shifts.size).to eq(1)
      expect(shifts[0]).to eq(@s3)
    end

    it 'works with more than one' do
      s = DateTime.new(2020,5,30,0,0,15)
      e = DateTime.new(2020,6,3,0,0,15)
      shifts = @user.over_dates(s, e)
      expect(shifts.size).to eq(2)
      expect(shifts[0]).to eq(@s2)
      expect(shifts[1]).to eq(@s3)
    end

    it 'includes shifts that go outside the range' do
      s = DateTime.new(2020,5,31,8,0,15)
      e = DateTime.current
      shifts = @user.over_dates(s, e)
      expect(shifts.size).to eq(1)
      expect(shifts[0]).to eq(@s3)

      s = DateTime.new(2020,5,29,0,0,15)
      e = DateTime.new(2020,5,30,10,0,15)
      shifts = @user.over_dates(s, e)
      expect(shifts.size).to eq(2)
      expect(shifts[0]).to eq(@s1)
      expect(shifts[1]).to eq(@s2)
    end
    it 'ignores unfinished shifts' do 
      s = DateTime.new(2020,6,5,4,3,15)
      Shift.create!(start: s, user: @user)

      s = DateTime.new(2020,4,29,0,0,15)
      e = DateTime.new(2020,7,30,10,0,15)
      shifts = @user.over_dates(s,e)
      expect(shifts.size).to eq(3)
    end
  end

  context 'calc wages over date range' do
    before(:each) do
      start_time = DateTime.new(2020,5,29,9,0,15)
      end_time = DateTime.new(2020,5,29,17,30,15)
      @s1 = Shift.create!(start: start_time, end: end_time, user: @user)

      start_time = DateTime.new(2020,5,30,7,0,15)
      end_time = DateTime.new(2020,5,30,15,0,15)
      @s2 = Shift.create!(start: start_time, end: end_time, user: @user)

      start_time = DateTime.new(2020,5,31,7,0,15)
      end_time = DateTime.new(2020,5,31,16,0,15)
      @s3 = Shift.create!(start: start_time, end: end_time, user: @user)
    end

    it 'returns zero if time is too recent' do
      dt = DateTime.new(2020,6,5,12,20,0)
      expect(@user.wages_over_dates(dt)).to eq(0)
    end
    it 'returns wages for for simple input' do
      dt = DateTime.new(2020,5,31,1,0,0)
      expect(@user.wages_over_dates(dt)).to eq(9 * 10.00)
    end
    it 'returns partial for dt that starts in middle of shift' do
      dt = DateTime.new(2020,5,31,10,0,15)
      expect(@user.wages_over_dates(dt)).to eq(6 * 10.00)
    end
    it 'can calculate wages in last 30 days' do
      expect(@user.wages_last_30_days).to eq(25.5 * 10.0)
    end
    it 'can calculate wages since beginning of month' do
      start_time = DateTime.new(2020,6,10,7,0,15)
      end_time = DateTime.new(2020,6,10,16,0,15)
      Shift.create!(start: start_time, end: end_time, user: @user)
      expect(@user.wages_since_month_start).to eq(9 * 10)
    end
    it 'handles date ranges' do
      dt_start = DateTime.new(2020,5,30,1,0,0)
      dt_end = DateTime.new(2020,5,31,23,0,0,)
      expect(@user.wages_over_dates(dt_start, dt_end)).to eq(17 * 10)
    end
    it 'handles date ranges with shifts that go over range' do 
      dt_start = DateTime.new(2020,5,30,10,0,15)
      dt_end = DateTime.new(2020,5,31,10,30,15)
      expect(@user.wages_over_dates(dt_start, dt_end)).to eq(8.5 * 10)
    end
  end
end
