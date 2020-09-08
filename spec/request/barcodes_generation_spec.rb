require 'rails_helper'

RSpec.describe 'Barcodes generation', type: :request do
  let(:barcode_count) { Barcode.count }

  it 'generates barcodes' do
    expect do
      post '/barcodes/generate'
    end.to change{ Barcode.count }.from(0)
  end

  it 'generates between 1-100 barcodes' do
    post '/barcodes/generate'
    expect(Barcode.count).to be_between(1, 100)
  end

  it 'sets source to "generator"' do
    post '/barcodes/generate'
    expect(Barcode.pluck(:source).uniq!).to match_array(['generator'])
  end
end