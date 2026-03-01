# frozen_string_literal: true

module LoginHelper
  def login_user(user)
    post user_session_path, params: {
      user: {
        email: user.email,
        password: 'password'
      }
    }
  end
end

RSpec.configure do |config|
  config.include LoginHelper, type: :request
end
