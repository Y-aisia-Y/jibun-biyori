class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :records, dependent: :destroy
  has_many :record_items, dependent: :destroy
  has_many :user_record_items, dependent: :destroy

  after_create :create_default_record_items

  # Devise の設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # CarrierWaveのマウント
  mount_uploader :avatar, AvatarUploader
  
  # プロフィール用のバリデーション
  validates :nickname, length: { maximum: 50 }, allow_blank: true
  validates :first_name, length: { maximum: 50 }, allow_blank: true
  validates :last_name, length: { maximum: 50 }, allow_blank: true

  private

  def create_default_record_items
    default_items = [
      { name: "睡眠時間", input_type: :time_range, unit: "時間", display_order: 1 },
      { name: "気分", input_type: :five_step, display_order: 2 },
      { name: "体調", input_type: :five_step, display_order: 3 },
      { name: "意欲", input_type: :five_step, display_order: 4 },
      { name: "疲労感", input_type: :five_step, display_order: 5 }
    ]

    default_items.each do |attrs|
      record_items.create!(
        attrs.merge(
          is_default: true,
          is_default_visible: true
        )
      )
    end
  end
end
