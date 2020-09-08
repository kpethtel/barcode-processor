class BarcodeGeneratorService

  LOWEST = 0.freeze

  attr_reader :number_generated

  def initialize(requested_number = nil)
    @number_generated = requested_number || random_number
  end

  def execute
    generate
  end

  private

  def random_number
    rand(1..100)
  end

  def generate
    created_count = 0
    current_num = LOWEST
    until created_count == number_generated do
      code = current_num.to_s.rjust(7, '0')
      ean8 = EAN8.complete(code)
      barcode = Barcode.new(ean8: ean8, source: 'generator')
      created_count += 1 if barcode.save
      current_num += 1
    end
  end

end
