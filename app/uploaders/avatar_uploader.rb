class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "/var/www/business.gtech.site/shared/public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    # "/home/alison/Documents"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  include CarrierWave::MiniMagick

  ## Tamanhos que o CarrierWave vai salvar as imagens

  # 50
  version :size50 do
    process resize_to_fit: [50, 50]
  end

  # 80
  version :size80 do
    process resize_to_fit: [80, 80]
  end

  # 100
  version :size100 do
    process resize_to_fit: [100, 100]
  end

  # 150
  version :size150 do
    process resize_to_fit: [500, 500]
  end

  # Tipos de extensão aceitas
  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
