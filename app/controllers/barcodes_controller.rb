class BarcodesController < ApplicationController

  def import
  end

  def upload
    process_barcode_file
    if error
      flash.alert = error
      return render :import
    end
    if failures.any?
      flash.alert = "Invalid barcodes found: #{failures.join(', ')}"
      return render :import
    end
    flash.notice = "#{successes.count} barcodes imported!"
    redirect_to :root
  end

  def generate
    generate_random_barcodes
    flash.notice = "#{generator.number_generated} barcodes generated"
    redirect_to :root
  end

  private

  def generate_random_barcodes
    generator.execute
  end

  def generator
    @generator ||= BarcodeGeneratorService.new
  end

  def file
    @file ||= params.dig(:upload, :file)
  end

  def importer
    @importer ||= BarcodeImporterService.new(file)
  end

  def process_barcode_file
    importer.process
  end

  def successes
    importer.barcode_statuses[:success]
  end

  def failures
    importer.barcode_statuses[:failure]
  end

  def error
    importer.barcode_statuses[:error]
  end
end
