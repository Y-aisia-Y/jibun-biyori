class Mypage::RecordItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record_item, only: [:toggle_visibility]

  def toggle_visibility
    @record_item.update!(is_default_visible: !@record_item.is_default_visible)
    head :ok
  end

  private

  def set_record_item
    @record_item = current_user.record_items.system_items.find(params[:id])
  end
end