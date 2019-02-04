class LocationsController < ApplicationController
  def index
    page = params[:page].nil? ? 1 : params[:page].to_i
    locations = Location.ip_list.offset(page * 15 - 15).limit(15)
    locations = locations.map { |l| {l.ip => l.users.pluck(:login) } }
    render json: locations.to_json
  end
end
