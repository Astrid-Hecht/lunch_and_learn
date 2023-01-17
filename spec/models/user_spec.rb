require 'rails_helper'

RSpec.describe User, :vcr, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :api_key }
    it { should validate_uniqueness_of :api_key }
  end
end