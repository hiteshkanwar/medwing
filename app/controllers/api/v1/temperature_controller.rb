class Api::V1::TemperatureController < ApplicationController
  require 'sidekiq/api'
  # reading post and get method
  def reading
    if request.post?
      @number =  !@thermostat.readings.blank? ? @thermostat.readings.last.id + 1 : 0
      @reading = CreateReading.perform_async(@thermostat.id, params[:temperature], params[:humidity], params[:battery_charge], @number)
      if @reading
        render json: {status: "success", code: 200, reading_job_id: @reading, sequence_number: @number}
      else
        render json: {status: "error", code: 404, message: @reading.errors}
      end   
    elsif request.get?
       @reading = Reading.find_by_id(params[:id]) 
       @thermostat = @reading.thermostat if !@reading.blank?
       @thermostat = thermostate_in_sidekiq_queue(params[:id]) if @reading.blank?
      if @thermostat 
        render json: {status: "success", code: 200, thermostat: @thermostat}
      else
        render json: {status: "error", code: 404, message: "Can not find the reading"}
      end  
    end 
  end
  # reading stats data
  def stats
    if !@thermostat.readings.blank?
      avg_stats_sidekiq_queue
      avg_temp = avg_stats_sidekiq_queue["temperature"] > 0 ? (avg_stats_sidekiq_queue["temperature"] + @thermostat.readings.sum(:temperature).to_f )/(avg_stats_sidekiq_queue["count"] + @thermostat.readings.count) : @thermostat.readings.average(:temperature).to_f 
      avg_humidity = avg_stats_sidekiq_queue["humidity"] > 0 ? (avg_stats_sidekiq_queue["humidity"] + @thermostat.readings.sum(:humidity).to_f )/(avg_stats_sidekiq_queue["count"] + @thermostat.readings.count) : @thermostat.readings.average(:humidity).to_f 
      avg_battery_charge = avg_stats_sidekiq_queue["battery_charge"] > 0 ? (avg_stats_sidekiq_queue["battery_charge"] + @thermostat.readings.sum(:battery_charge).to_f )/(avg_stats_sidekiq_queue["count"] + @thermostat.readings.count) : @thermostat.readings.average(:battery_charge).to_f 
      render json: {status: "success", code: 200, avg_temp: avg_temp, avg_humidity: avg_humidity, avg_battery_charge: avg_battery_charge}
    else
      render json: {status: "error", code: 404, message: "Can not find the reading"}
    end
  end

  private
  # thermostat from backgound process
  def thermostate_in_sidekiq_queue(reading_id)
    queue = Sidekiq::Queue.new
    queue.each do |job|
      if job.args[4] == reading_id.to_i
         thermostat = Thermostat.find_by_id(job.args[0])
         return thermostat
      end
    end
  end
  # avg stats
  def avg_stats_sidekiq_queue
    avg_stats = {}
    avg_stats["temperature"]  = 0
    avg_stats["humidity"] = 0
    avg_stats["battery_charge"] = 0
    queue = Sidekiq::Queue.new
    avg_stats["count"] = queue.count
    queue.each do |job|
      avg_stats["temperature"]= avg_stats["temperature"].to_f + job.args[1].to_f
      avg_stats["humidity"] = avg_stats["humidity"].to_f + job.args[2].to_f
      avg_stats["battery_charge"] = avg_stats["battery_charge"].to_f + job.args[3].to_f
    end
    return avg_stats
  end

end
