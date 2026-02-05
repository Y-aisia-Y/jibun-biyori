# frozen_string_literal: true

FactoryBot.define do
  factory :user_record_item do
    user { nil }
    record_item { nil }
    is_visible { false }
    display_order { 1 }
  end
end
