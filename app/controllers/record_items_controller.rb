class RecordItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record_item, only: %i[edit update destroy move_up move_down toggle_visibility]

  def index
    @record_items = current_user.record_items.ordered
  end

  def new
    @record_item = current_user.record_items.build(category: "custom")
  end

  def create
    max_order = current_user.record_items.maximum(:display_order) || 0
    @record_item = current_user.record_items.build(record_item_params)
    @record_item.display_order = max_order + 1
    @record_item.category = "custom"

    if @record_item.save
      redirect_to mypage_path, notice: "記録項目を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @record_item.update(record_item_update_params)
      redirect_to mypage_path, notice: "記録項目を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @record_item.default?
      redirect_to mypage_path, alert: "デフォルト項目は削除できません"
    else
      @record_item.destroy
      redirect_to mypage_path, notice: "記録項目を削除しました"
    end
  end

  def toggle_visibility
    @record_item.update!(is_default_visible: !@record_item.is_default_visible)
    redirect_to mypage_path
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
end
