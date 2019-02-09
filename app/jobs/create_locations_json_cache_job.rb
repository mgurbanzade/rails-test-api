class CreateLocationsJsonCacheJob < ApplicationJob
  queue_as :default

  def perform(*args)
    locations = Location.select(:id, :ip).group(:id, :ip)

    response = Rails.cache.fetch(Location.cache_key(locations)) do
      locations.includes(:users).map { |l| { l.ip => l.users.pluck(:login).uniq } }.to_json
    end
  end
end
