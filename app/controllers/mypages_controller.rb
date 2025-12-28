class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @default_items = current_user.record_items.where(category: "default").order(:display_order)
    @custom_items  = current_user.record_items.where(category: "custom").order(:display_order)
  end
end
