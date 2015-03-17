class Spot < ActiveRecord::Base

  has_attached_file :image, styles: { large: '1600x1600>',
                                      medium: '800x800>',
                                      small: '400x400>',
                                      thumb: '100x100>' }

  def self.current_spot
    Spot.last
  end

  def image_url
    image.url(:medium)
  end

end