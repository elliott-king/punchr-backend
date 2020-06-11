# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all

User.create!(first_name: "Elliott", last_name: "King", email: "something1@somewhere.com", phone: "8675309", pin: 7777, password: "elliott")
User.create!(first_name: "test", last_name: "account", email: "something2@somewhere.com", phone: "8675309", pin: 9999, password: "test")