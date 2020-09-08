class Barcode < ActiveRecord::Base
  validates_uniqueness_of :ean8
  validate :ean8_validity

  def ean8_validity
    EAN8.valid?(ean8)
  end
end
