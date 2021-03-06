class User < ApplicationRecord
  has_secure_password
  has_many :articles, dependent: :destroy
  # save the email in downcase
  before_save { self.email = email.downcase }

  VALID_FORMAT_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username, presence: true, uniqueness: {case_sensitive: false},
            length: {minimum: 3, maximum: 25}, format: {without: /\s/i}
  validates :email, presence: true, uniqueness: {case_sensitive: false},
            length:{maximum: 50}, format: {with: VALID_FORMAT_REGEX}
end
