# frozen_string_literal: true

FactoryBot.define do
  factory :record do
    association :user
    recorded_date { "2025-11-25" }
    diary_memo { "MyText" }
  end
end
