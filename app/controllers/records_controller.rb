class RecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: %i[show edit update destroy]
  before_action :check_user, only: %i[show edit update destroy]

  def index
    @records = current_user.records.order(recorded_date: :desc)
  end

  def show
  end

  def new
    @record = current_user.records.build(recorded_date: Date.current)
    @record_items = RecordItem.all.order(:display_order)
    @record_items.each do |item|
      unless @record.record_values.any? { |v| v.record_item_id == item.id }
        @record.record_values.build(record_item: item)
      end
    end
  end

  def create
    @record = current_user.records.build(record_params)

    if @record.save
      redirect_to records_path, success: '記録を作成しました'
    else
      @record_items = RecordItem.all.order(:display_order)
      build_record_values
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    build_record_values
  end

  def update
    if @record.update(record_params)
      redirect_to @record, notice: '記録を更新しました。'
    else
      build_record_values
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @record.destroy!
    redirect_to records_url, notice: '記録を削除しました。', status: :see_other
  end


  private


  def set_record
    @record = Record.find(params[:id])
  end

  def check_user
    unless @record.user_id == current_user.id
      redirect_to records_path, alert: 'アクセス権限がありません。'
    end
  end

  def build_record_values
    @record_items = RecordItem.all
    @record_items.each do |item|
      unless @record.record_values.any? { |v| v.record_item_id == item.id }
        @record.record_values.build(record_item: item)
      end
    end
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
