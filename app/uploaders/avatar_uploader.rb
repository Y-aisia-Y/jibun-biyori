# frozen_string_literal: true

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # サムネイル版を作成
  version :thumb do
    process resize_to_fill: [100, 100]
  end

  # 通常サイズ版を作成
  version :medium do
    process resize_to_fill: [300, 300]
  end

  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  def default_url
    # デフォルト画像を使わない場合はnilを返す
    nil
  end
end
