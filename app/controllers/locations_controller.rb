class LocationsController < ApplicationController
  def index
    page = params[:page].nil? ? 1 : params[:page].to_i
    locations = Location.with_offset(page * 15 - 15)

    response = Rails.cache.fetch(Location.cache_key(locations)) do
      locations.includes(:users).map { |l| { l.ip => l.users.pluck(:login).uniq } }.to_json
    end

    render json: response
  end
end
