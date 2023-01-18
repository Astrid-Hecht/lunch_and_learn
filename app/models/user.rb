class User < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates_presence_of :api_key
  validates_uniqueness_of :api_key

  has_many :favorites, dependent: :destroy

end
