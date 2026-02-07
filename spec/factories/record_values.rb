# frozen_string_literal: true

FactoryBot.define do
  factory :record_value do
    record { nil }
    record_item { nil }
    value { "MyString" }
  end
end
