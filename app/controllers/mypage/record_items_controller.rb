# frozen_string_literal: true

module Mypage
  class RecordItemsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_record_item, only: [:toggle_visibility]

    def toggle_visibility
      @record_item.update!(is_default_visible: !@record_item.is_default_visible)
      head :ok

      respond_to do |format|
        format.html { redirect_to mypage_record_item_settings_path, notice: '表示設定を更新しました' }
        format.turbo_stream
      end
    end

    private

    def set_record_item
      @record_item = current_user.record_items.find(params[:id])
    end
  end
end
