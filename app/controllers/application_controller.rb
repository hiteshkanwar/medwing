class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :authenticate_request
  
  private

  def authenticate_request
    token = request.headers["Household-Token"]
    @thermostat = Thermostat.find_by_household_token(token)
    render json: { error: 'Not Authorized' }, status: 401 if @thermostat.blank?
  end

end
