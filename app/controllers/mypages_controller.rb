class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @record_items = current_user.record_items
    @record_items = current_user.record_items.order(:display_order)
  end
end
