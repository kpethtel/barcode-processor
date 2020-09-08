require 'rails_helper'

RSpec.describe 'Barcodes import', type: :request do
  let(:file) { fixture_file_upload(File.join(Rails.root, 'doc/task1_barcodes.xlsx')) }

  it 'creates barcodes for valid ean8s' do
    expect {
      post '/barcodes/import', params: { upload: { file: file }}
    }.to change{ Barcode.count }.from(0).to(4)
  end
end