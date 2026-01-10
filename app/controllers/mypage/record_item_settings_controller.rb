class Mypage::RecordItemSettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    @visible_system_items = current_user.record_items.system_items.visible.ordered
    @hidden_system_items  = current_user.record_items.system_items.hidden.ordered
  end
end
