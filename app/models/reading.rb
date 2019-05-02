class Reading < ApplicationRecord
  belongs_to :thermostat
  # validate reading with temperature humidity and battery charge
  validates :temperature, presence: true
  validates :humidity, presence: true
  validates :battery_charge, presence: true
end
