# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { "test-#{SecureRandom.hex(4)}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
