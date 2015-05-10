class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validate :device_id, uniqueness: { scope: :email, message: "has already been registered" }
  validate :email, uniqueness: { allow_blank: true }

  before_save :ensure_authentication_token

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def session
    raise StandardError.new("Can't return session for uninitialized user") unless (id && authentication_token)

    {
      user_id: id,
      authentication_token: authentication_token
    }
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
