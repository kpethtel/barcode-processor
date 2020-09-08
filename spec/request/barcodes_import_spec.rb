require 'rails_helper'

RSpec.describe 'Barcodes import', type: :request do
  let(:file) { fixture_file_upload(file_fixture('task2_barcodes.xlsx')) }

  describe 'file upload' do
    it 'creates Barcodes' do
      expect do
        post '/barcodes/import', params: { upload: { file: file }}
      end.to change{ Barcode.count }.from(0).to(4)
    end

    it 'creates Barcodes only for valid ean8 codes' do
      post '/barcodes/import', params: { upload: { file: file }}
      barcodes = Barcode.pluck(:ean8)
      expected = %w[00000031 00000079 00000093 12345670]
      expect(barcodes).to match_array(expected)
    end
  end
end