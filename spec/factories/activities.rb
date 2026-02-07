# frozen_string_literal: true

FactoryBot.define do
  factory :activity do
    record { nil }
    start_time { "2025-11-25 22:37:23" }
    end_time { "2025-11-25 22:37:23" }
    content { "MyText" }
  end
end
