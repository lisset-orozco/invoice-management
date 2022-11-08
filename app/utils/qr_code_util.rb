# frozen_string_literal: true

class QrCodeUtil < ApplicationUtil
  def initialize(params)
    super()

    @params = params
  end

  def call
    raise(StandardError, 'Missing params') if params.blank?

    response(success: true, payload: generate_qr_code_image)
  rescue => error
    response(error: { source: self.class.to_s, message: error.message })
  end

  private

  attr_reader :params

  def generate_qr_code_image
    qrcode = RQRCode::QRCode.new(params[:str_qr])
    qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: 'black',
      file: nil,
      fill: 'white',
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 320
    )
  end
end
