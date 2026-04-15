# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    def guest_sign_in
      guest_user = User.create!(
        email: "guest_#{SecureRandom.hex(8)}@jibun-biyori.com",
        password: SecureRandom.hex(16),
        guest: true
      )
      sign_in guest_user
      redirect_to root_path, notice: t(".guest_signed_in")
    end

    def guest_sign_out
      sign_out current_user
      # ログアウト直後に新規登録画面へ
      redirect_to new_user_registration_path, notice: t(".guest_signed_out")
    end
  end
end
