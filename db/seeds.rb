Shift.destroy_all
User.destroy_all


10.times do
  User.create!({
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.safe_email,
    phone: Faker::PhoneNumber.cell_phone,
    hourly_wage: Faker::Number.within(range: 12..30),
    is_manager: false,
    pin: Faker::Number.number(digits: 4),
    password: 'password'
    })
end

200.times do
  start_time = Faker::Time.backward(days:200)
  end_time = Faker::Time.between(from: start_time, to: start_time + 12.hours)
  Shift.create!({
    user_id: User.all.sample.id,
    start: start_time,
    end: end_time
    })
end

5.times do
  Shift.create({
    user_id: User.all.sample.id,
    start: Faker::Time.between(from: DateTime.now - 8.hours, to: DateTime.now),
    end: nil
    })
  end
