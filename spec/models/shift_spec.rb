require 'rails_helper'

RSpec.describe Shift, type: :model do
  before(:each) do
    @elliott = User.create!(first_name: "Elliott", last_name: "King", email: "something1@somewhere.com", phone: "8675309", pin: 7777, password: "elliott", hourly_wage: 10.00)
    @user = User.create!(first_name: "test", last_name: "account", email: "something2@somewhere.com", phone: "8675309", pin: 9999, password: "test", hourly_wage: 20)
    @hobbes = User.create!(first_name: "Calvin", last_name: "Hobbes", email: "something3@somewhere.com", phone: "8675309", pin: 0000, password: "test", hourly_wage: 20)
    start_time = DateTime.new(2020,5,30,7,0,15)
    end_time = DateTime.new(2020,5,30,15,3,26)
    Shift.create!(start: start_time, end: end_time, user: @elliott)
    
    start_time = DateTime.new(2020,5,29,9,0,15)
    end_time = DateTime.new(2020,5,29,17,0,26)
    Shift.create!(start: start_time, end: end_time, user: @elliott)
    
    start_time = DateTime.new(2020,5,31,7,0,15)
    Shift.create!(start: start_time, user: @elliott)

    start_time = DateTime.new(2020,6,10,7,0,15)
    Shift.create!(start: start_time, user: @hobbes)
  end

  context 'viewing current shifts' do
    it 'return an empty array if none exist' do
      @elliott.punch
      @hobbes.punch
      expect(Shift.current.count).to eq(0)
    end
    it 'return current shifts' do
      shifts = Shift.current 
      users = [@elliott, @hobbes]
      expect(users).to include(shifts[0].user)
      expect(users).to include(shifts[1].user)
    end
  end

  context 'view shifts over date range' do
    it 'handle simple input' do
      s = DateTime.new(2020,5,29,1,3,26)
      e = DateTime.new(2020,5,30,16,3,26)
      expect(Shift.over_dates(s, e).count).to eq(2)
    end
    it 'returns ongoing shifts' do
      s = DateTime.new(2020,5,27,1,3,26)
      e = DateTime.now
      expect(Shift.over_dates(s, e).count).to eq(4)
    end
    it 'returns shifts that are partly outside bounds' do
      s = DateTime.new(2020,5,29,10,3,26)
      e = DateTime.new(2020,5,30,10,3,26)
      expect(Shift.over_dates(s, e).count).to eq(2)
    end
  end
end
