class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :records, dependent: :destroy
  has_many :record_items, dependent: :destroy
  has_many :user_record_items, dependent: :destroy

  after_create :create_default_record_items
end
