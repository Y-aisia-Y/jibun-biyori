class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :records, dependent: :destroy
  has_many :record_items, dependent: :destroy
  has_many :user_record_items, dependent: :destroy

  after_create :create_default_record_items

  private

  def create_default_record_items
    record_items.create!(
      name: "気分",
      input_type: :five_step,
      display_order: 0,
      is_default: true,
      is_default_visible: true
    )
  end
end
