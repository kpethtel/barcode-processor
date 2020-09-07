# read xml
worksheet = RubyXL::Parser.parse(path)[0]
worksheet.each.with_index do |row, i|
  ...
end

# write xml
workbook = RubyXL::Workbook.new
worksheet = workbook[0]
worksheet.add_cell(0, 0, "Barcode")

# validate ean8
EAN8.new(ean8).valid?

# add checksum to 7-digit string so it's a valid ean8
EAN8.complete(value) # 0234567 -> 02345673
