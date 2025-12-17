class RecordItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record_item, only: %i[edit update destroy move_up move_down]

  def index
    @record_items = current_user.record_items.order(:display_order)
  end

  def new
    @record_item = current_user.record_items.build
  end

  def create
    max_order = current_user.record_items.maximum(:display_order) || 0
    @record_item = current_user.record_items.build(record_item_params)
    @record_item.display_order = max_order + 1

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
    record_item = current_user.record_items.find(params[:id])
    record_item.destroy

    redirect_to mypage_path, notice: "記録項目を削除しました"
  end

  def toggle_visibility
    record_item = current_user.record_items.find(params[:id])

    record_item.update!(
      is_default_visible: !record_item.is_default_visible
    )

    redirect_to mypage_path
  end

  def move_up
    swap_item = current_user.record_items.where("display_order < ?", @record_item.display_order).order(display_order: :desc).first
    swap_display_order(swap_item)
  end

  def move_down
    swap_item = current_user.record_items.where("display_order > ?", @record_item.display_order).order(display_order: :asc).first
    swap_display_order(swap_item)
  end

  private

  def swap_display_order(swap_item)
    return redirect_to mypage_path if swap_item.nil?

    RecordItem.transaction do
      current = @record_item.display_order
      @record_item.update!(display_order: swap_item.display_order)
      swap_item.update!(display_order: current)
    end

    redirect_to mypage_path
  end

  def set_record_item
    @record_item = current_user.record_items.find(params[:id])
  end

  def record_item_params
    params.require(:record_item).permit(
      :name,
      :unit,
      :input_type,
      :value_type,
      :display_order,
      :enabled
    )
  end

  def record_item_update_params
    params.require(:record_item).permit(:name, :unit)
  end
end
