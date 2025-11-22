require 'rails_helper'

RSpec.describe User, type: :model do

  it 'は有効な属性を持つ場合、有効であること' do
    user = build(:user)
    user = User.new(
      email: 'test@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    )
    expect(user).to be_valid
  end

  it 'はemailがない場合、無効であること' do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'はパスワードが短すぎる場合（5文字）、無効であること' do
    user = User.new(
      email: 'short@example.com',
      password: 'short',
      password_confirmation: 'short'
    )
    user.valid?
    expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
  end
end
