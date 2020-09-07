class BarcodesController < ApplicationController
  before_action :process_barcode_file, only: :upload

  def import
  end

  def upload
    if error
      flash.alert = error
      return render :import
    end
    if failures.any?
      flash.alert = "Invalid barcodes found: #{failures.join(', ')}"
      return render :import
    end
    flash.alert = "#{successes.count} barcodes imported!"
    redirect_to :root
  end

  private

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
