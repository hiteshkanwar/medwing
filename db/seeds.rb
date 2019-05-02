# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

locations = ['test1 apartment', 'test2 apartment', 'test3 apartment']

locations.each do |location|
  Thermostat.create(household_token: SecureRandom.hex(12), location: location)
end