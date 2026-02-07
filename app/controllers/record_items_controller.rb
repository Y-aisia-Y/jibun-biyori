# frozen_string_literal: true

class RecordItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record_item, only: %i[edit update destroy move_up move_down toggle_visibility]
  before_action :reject_default_item, only: %i[edit update destroy]

  def index
    @record_items = current_user.record_items.user_items.ordered
  end

  def new
    @record_item = current_user.record_items.build(category: "custom")
  end

  def edit; end

  def create
    max_order = current_user.record_items.maximum(:display_order) || 0
    @record_item = current_user.record_items.build(record_item_params)
    @record_item.display_order = max_order + 1
    @record_item.category = "custom"
    @record_item.item_type = "user_defined"

    if @record_item.save
      redirect_to record_items_path, success: "記録項目を作成しました"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @record_item.update(record_item_update_params)
      redirect_to record_items_path, success: "カスタム項目を更新しました"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @record_item.system?
      redirect_to record_items_path, warning: "記録項目は削除できません"
    else
      @record_item.destroy
      redirect_to record_items_path, danger: "カスタム項目を削除しました"
    end
  end

  def move_up
    return redirect_to mypage_root_path, status: :see_other unless @record_item.custom?

    @record_item.move_higher!
    redirect_to record_items_path, status: :see_other
  end

  def move_down
    return redirect_to mypage_root_path, status: :see_other unless @record_item.custom?

    @record_item.move_lower!
    redirect_to record_items_path, status: :see_other
  end

  def toggle_visibility
    @record_item.update!(is_default_visible: !@record_item.is_default_visible?)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "record_item_#{@record_item.id}",
            partial: "record_items/custom_item",
            locals: { item: @record_item }
          )
        ]
      end
      format.html { redirect_to record_items_path }
    end
  end

  private

  def set_record_item
    @record_item = current_user.record_items.find(params[:id])
  end

  def record_item_params
    params.require(:record_item).permit(:name, :unit, :input_type)
  end

  def record_item_update_params
    params.require(:record_item).permit(:name, :unit)
  end

  def reject_default_item
    return unless @record_item&.default?

    redirect_to mypage_path, warning: "記録項目は編集・削除できません"
  end
end
