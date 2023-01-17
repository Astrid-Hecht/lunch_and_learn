require 'faker'
require 'securerandom'

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email.downcase }
    api_key { SecureRandom.hex }
  end
end
