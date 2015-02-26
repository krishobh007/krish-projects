class Qrcode
  require 'rqrcode_png'

  def self.get_qr_code_blob(qr_string)
    qr = RQRCode::QRCode.new(qr_string, size: 10, level: :h)
    png = qr.to_img
    png = png.resize(300, 300)
    blob_data = png.to_blob
    blob_data
  end
end
