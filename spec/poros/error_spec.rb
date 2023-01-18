require 'rails_helper'

RSpec.describe Error do
  let(:error) do
    Error.new(404, 'Resource not found')
  end

  it 'attributes' do
    expect(error.status).to eq(404)
    expect(error.msg).to eq('Resource not found')
  end
end