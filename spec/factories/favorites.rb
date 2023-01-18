require 'faker'
require 'securerandom'

FactoryBot.define do
  factory :favorite do
    user
    country { Faker::Address.country }
    recipe_link { Faker::Internet.url }
    recipe_title { Faker::Marketing.buzzwords }
  end
end
