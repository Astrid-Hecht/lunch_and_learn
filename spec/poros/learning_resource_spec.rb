require 'rails_helper'

RSpec.describe LearningResource do
  let(:learning_resource_data) do
    { country: 'China', video: 'www.youtube.com', images: ['www.pic1.com', 'www.pic2.com'] }
  end
  let(:learning_resource) { LearningResource.new(learning_resource_data) }

  it 'attributes' do
    expect(learning_resource.country).to eq('China')
    expect(learning_resource.video).to eq('www.youtube.com')
    expect(learning_resource.images).to be_an Array
    expect(learning_resource.images).to eq(['www.pic1.com', 'www.pic2.com'])
  end
end
