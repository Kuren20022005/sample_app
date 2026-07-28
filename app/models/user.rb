class User < ApplicationRecord
  before_save :downcase_email

  validates :name,
            presence: true,
            length: {maximum: Settings.user.name.maximum}

  validates :email,
            presence: true,
            length: {maximum: Settings.user.email.maximum},
            format: {with: Settings.user.email.regex},
            uniqueness: {case_sensitive: false}

  has_secure_password

  private

  def downcase_email
    self.email = email.downcase
  end
end
