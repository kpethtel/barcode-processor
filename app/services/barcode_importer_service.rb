class BarcodeImporterService

  attr_reader :file
  attr_reader :parsed_file
  attr_accessor :barcode_statuses

  def initialize(file)
    @file = file
    @barcode_statuses = { success: [], failure: [], error: nil }
    validate_file
    validate_file_extension unless barcode_statuses[:error]
    parse_file unless barcode_statuses[:error]
  end

  def process
    return if barcode_statuses[:error]
    process_barcodes
  end

  private

  def validate_file
    if !file || file.class != ActionDispatch::Http::UploadedFile
      barcode_statuses[:error] = 'No file uploaded'
    end
  end

  def validate_file_extension
    if File.extname(file.path) != '.xlsx'
      barcode_statuses[:error] = 'Uploaded file must be of type .xlsx'
    end
  end

  def parse_file
    @parsed_file = RubyXL::Parser.parse(file.path)
  rescue Zip::Error => e
    barcode_statuses[:error] = 'File error'
  end

  def worksheet
    parsed_file[0]
  end

  def data_rows
    @data_rows ||= worksheet.sheet_data.rows[1..-1]
  end

  def barcodes
    @barcodes ||= data_rows.map do |row|
      next if row[0].value.nil?
      row[0].value.to_s
    end.compact
  end

  def process_barcodes
    barcodes.each do |code|
      status = nil
      code8 = coerce_to_ean8(code)
      if EAN8.valid?(code8)
        barcode = Barcode.new(ean8: code8, source: 'excel')
        status = barcode.save ? :success : :failure
      else
        status = :failure
      end
      barcode_statuses[status] << code8
    end
  end


  def coerce_to_ean8(code)
    length = code.length
    return nil if length > 8
    return code if length == 8
    code_to_seven = code.rjust(7, '0')
    code_to_eight = '0' + code_to_seven
    return code_to_eight if EAN8.valid?(code_to_eight)
    EAN8.complete(code_to_seven)
  end
end