class RecordValuesController < ApplicationController
  before_action :set_record

  def create
    @record_value = @record.record_values.new(record_value_params)
    if @record_value.save
      redirect_to @record, success: "保存しました"
    else
      redirect_to @record, warning: "保存に失敗しました"
    end
  end

  def update
    @record_value = @record.record_values.find(params[:id])
    if @record_value.update(record_value_params)
      redirect_to @record, success: "更新しました"
    else
      redirect_to @record, warning: "更新に失敗しました"
    end
  end

  private

  def set_record
    @record = current_user.records.find(params[:record_id])
  end

  def record_value_params
    params.require(:record_value).permit(
      :record_item_id, 
      :value,
      # 時間範囲用の仮想属性
      :sleep_hour, 
      :sleep_minute, 
      :wake_hour, 
      :wake_minute
    )
  end
end
