require 'rails_helper'

RSpec.describe LearningResource do
  let(:learning_resource) do
    LearningResource.new('China', 'www.youtube.com', ['www.pic1.com', 'www.pic2.com'])
  end

  it 'attributes' do
    expect(learning_resource.country).to eq('China')
    expect(learning_resource.video).to eq('www.youtube.com')
    expect(learning_resource.images).to be_an Array
    expect(learning_resource.images).to eq(['www.pic1.com', 'www.pic2.com'])
  end
end
