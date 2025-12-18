class RecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: %i[show edit update destroy]
  before_action :check_user, only: %i[show edit update destroy]

  def index
    @records = current_user.records.order(recorded_date: :desc)
  end

  def show
    @record = current_user.records.find(params[:id])
    @record_items = current_user.record_items.where(is_default_visible: true).order(:display_order)
  end

  def new
    @record = current_user.records.build(recorded_date: Date.current)
    build_record_values
  end

  def edit
    build_record_values
  end

  def create
    @record = current_user.records.build(record_params_with_time_range)

    if @record.save
      redirect_to records_path, notice: "記録を保存しました"
    else
      build_record_values
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @record.update(record_params_with_time_range)
      redirect_to @record, notice: '記録を更新しました。'
    else
      build_record_values
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @record.destroy!
    redirect_to records_url, notice: '記録を削除しました。', status: :see_other
  end

  private

  def set_record
    @record = current_user.records.find(params[:id])
  end

  def check_user
    redirect_to records_path, alert: 'アクセス権限がありません。' unless @record.user_id == current_user.id
  end

  def build_record_values
    @record_items = current_user.record_items.where(is_default_visible: true).order(:display_order)
    @record_items.each do |item|
      next if @record.record_values.any? { |v| v.record_item_id == item.id }
      @record.record_values.build(record_item: item)
    end
  end

  def record_params_with_time_range
    params_hash = record_params.to_h

    if params_hash[:record_values_attributes]
      params_hash[:record_values_attributes].each do |key, rv_attr|
        next unless rv_attr[:sleep_time].present? && rv_attr[:wake_time].present?

        record_item = RecordItem.find_by(id: rv_attr[:record_item_id])
        next unless record_item&.input_type == "time_range"

        sleep_time = rv_attr[:sleep_time].presence || "00:00"
        wake_time = rv_attr[:wake_time].presence || "00:00"
        params_hash[:record_values_attributes][key][:value] = "#{sleep_time} - #{wake_time}"
      end
    end

    params_hash
  end

  def record_params
    params.require(:record).permit(
      :recorded_date,
      :diary_memo,
      record_values_attributes: [
        :id,
        :record_item_id,
        :value,
        :sleep_time,
        :wake_time,
        :_destroy
      ]
    )
  end
end
