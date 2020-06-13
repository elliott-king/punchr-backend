require 'date'

Shift.destroy_all
User.destroy_all

elliott = User.create!(first_name: "Elliott", last_name: "King", email: "something1@somewhere.com", phone: "8675309", pin: 7777, password: "elliott", hourly_wage: 10.00)
test = User.create!(first_name: "test", last_name: "account", email: "something2@somewhere.com", phone: "8675309", pin: 9999, password: "test", hourly_wage: 20.20)

# yyyy, m, d, h, min, sec
# 8hr 3min 11sec
start_time = DateTime.new(2020,5,30,7,0,15)
end_time = DateTime.new(2020,5,30,15,3,26)
Shift.create!(start: start_time, end: end_time, user: elliott)

# 8hr 11 sec
start_time = DateTime.new(2020,5,29,9,0,15)
end_time = DateTime.new(2020,5,29,17,0,26)
Shift.create!(start: start_time, end: end_time, user: elliott)

start_time = DateTime.new(2020,5,31,7,0,15)
Shift.create!(start: start_time, user: elliott)