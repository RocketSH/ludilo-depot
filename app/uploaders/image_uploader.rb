require "image_processing/mini_magick"

class ImageUploader < Shrine
  plugin :derivatives

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    { 
      thumbnail:  magick.resize_to_limit!(120, 120),
      profile: magick.resize_to_limit!(250, 250),
      display:  magick.resize_to_limit!(350, 350),
    }
  end

  Attacher.validate do
    validate_max_size 5*1024*1024, message: "is too large (max is 5 MB)"
    validate_mime_type %w[image/jpg image/jpeg image/png]
  end
end