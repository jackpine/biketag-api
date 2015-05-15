# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

class Seeds

  class_attribute :lucile_spot, :user

  def self.seed!
    self.lucile_spot = Spot.new location: { type: "Point",
                                  coordinates: [-118.281617, 34.086588] }
    lucile_image_path = Rails.root + 'db/seeds/images/952_lucile.jpg'
    File.open(lucile_image_path) do |lucile_image|
      lucile_spot.image = lucile_image
      lucile_spot.save!
    end

    self.user = User.create!
    self.user.create_api_key!
  end

  def self.auth_params
    { client_id: self.user.api_key.client_id }
  end
end
