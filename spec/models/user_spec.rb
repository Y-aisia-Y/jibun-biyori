# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it 'は有効な属性を持つ場合、有効であること' do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    it 'はemailがない場合、無効であること' do
      user = FactoryBot.build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to be_present
    end

    it 'はパスワードが短すぎる場合、無効であること' do
      user = FactoryBot.build(:user, password: 'abc', password_confirmation: 'abc')
      user.valid?
      expect(user.errors[:password]).to be_present
    end
  end
end
