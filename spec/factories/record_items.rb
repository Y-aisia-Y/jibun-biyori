# frozen_string_literal: true

FactoryBot.define do
  factory :record_item do
    name { "MyString" }
    input_type { 1 }
    is_default_visible { false }
  end
end
