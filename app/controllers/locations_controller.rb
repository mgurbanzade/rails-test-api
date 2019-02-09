class LocationsController < ApplicationController
  def index
    page = params[:page].nil? ? 1 : params[:page].to_i
    locations = Location.with_offset(page * 15 - 15)
    response = locations.includes(:users).map do |l|
      {
        l.ip => l.users.pluck(:login).uniq
      }
    end

    render json: response.to_json
  end
end
