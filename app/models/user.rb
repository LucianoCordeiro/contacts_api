class User < ApplicationRecord
  has_secure_password

  has_many :contacts, dependent: :delete_all

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: :password_required?

  def refresh_auth_token
    update!(auth_token: User.generate_token)
  end

  def refresh_reset_password_token
    update!(reset_password_token: User.generate_token)
  end

  def password_required?
    password.present?
  end

  def self.generate_token
    Digest::SHA1.hexdigest([Time.now, rand].join)
  end
end
