class Guess < ActiveRecord::Base

  belongs_to :spot
  validates :location, presence: true
  validates :spot, associated: true, presence: true
  #validates :correct, inclusion: { in: [true, false] }

  def correct
    self[:correct] ||= close_enough?
  end

  before_save do
    correct

    # if before_save returns false, the record won't save, so we force returning
    # true here so that incorrect guesses still save.
    true
  end

  def close_enough?
    raise RuntimeError.new("attempting to compare to non-existant spot") unless spot.present?
    raise RuntimeError.new("attempting to compare to empty location") unless spot.location.present? && self.location.present?

    # This distance was generated experimentally. It's about 250 feet.
    # I have no idea what unit this measurement could possibly be in.
    # Some gentle research says it's in "whatever unit your projection is in"
    self[:location].distance(spot[:location]) < 0.001
  end

  def location=(val)
    val = val.deep_stringify_keys if val.class == Hash
    self[:location] = RGeo::GeoJSON.decode(val).to_s
  end

  def location
    RGeo::GeoJSON.encode(self[:location])
  end
end