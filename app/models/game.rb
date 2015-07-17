class Game < ActiveRecord::Base
  has_many :spots
  has_many :guesses

  def current_spot
    spots.last
  end

  def name
    "Game #{id}"
  end
end