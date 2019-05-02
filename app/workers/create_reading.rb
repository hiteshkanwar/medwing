class CreateReading
  include Sidekiq::Worker

  def perform(*args) 
  	thermostat = Thermostat.find_by_id(args[0])
    @reading = thermostat.readings.new(:temperature=> args[1], :humidity=> args[2], :battery_charge=> args[3],:number=> args[4])
    @reading.save
  end 

end