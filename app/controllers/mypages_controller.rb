class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    # system（デフォルト）項目
    @visible_system_items = current_user.record_items.system_items.visible.ordered
    @hidden_system_items  = current_user.record_items.system_items.hidden.ordered

    # user_defined（カスタム）項目
    @custom_items = current_user.record_items.user_items.ordered
  end
end
