class User < ApplicationRecord

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
      { 
        name: "睡眠時間", 
        input_type: :time_range, 
        category: :default,
        display_order: 1,
        item_type: :system
      },
      { 
        name: "気分", 
        input_type: :five_step, 
        category: :default,
        display_order: 2,
        item_type: :system
      },
      { 
        name: "体調", 
        input_type: :five_step, 
        category: :default,
        display_order: 3,
        item_type: :system
      },
      { 
        name: "意欲", 
        input_type: :five_step, 
        category: :default,
        display_order: 4,
        item_type: :system
      },
      { 
        name: "疲労感", 
        input_type: :five_step, 
        category: :default,
        display_order: 5,
        item_type: :system
      }
    ]

    default_items.each do |attrs|
      record_items.create!(attrs)
    end
  end
end