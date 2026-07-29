class User < ApplicationRecord
  before_save :downcase_email

  validates :name,
            presence: true,
            length: {maximum: Settings.user.name.maximum}

  validates :email,
            presence: true,
            length: {maximum: Settings.user.email.maximum},
            format: {with: Regexp.new(Settings.user.email.regex,
                                      Regexp::IGNORECASE)},
            uniqueness: {case_sensitive: false}

  has_secure_password

  # Returns the hash digest of the given string.
  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost:
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
