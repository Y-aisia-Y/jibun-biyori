class RecordItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record_item, only: %i[edit update destroy]

  def index
    @record_items = current_user.record_items.order(:display_order)
  end

  def new
    @record_item = current_user.record_items.build
  end

  def create
    @record_item = current_user.record_items.build(record_item_params)

    if @record_item.save
      redirect_to record_items_path, notice: "記録項目を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @record_item.update(record_item_params)
      redirect_to record_items_path, notice: "記録項目を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @record_item.is_default
      redirect_to record_items_path, alert: "デフォルト項目は削除できません"
    else
      @record_item.destroy
      redirect_to record_items_path, notice: "記録項目を削除しました"
    end
  end

  private

  def set_record_item
    @record_item = current_user.record_items.find(params[:id])
  end

  def record_item_params
    params.require(:record_item).permit(
      :name,
      :value_type,
      :display_order,
      :enabled
    )
  end
end
