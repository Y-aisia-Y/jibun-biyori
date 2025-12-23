class RecordsController < ApplicationController
  include CurrentTimeSettable

  before_action :authenticate_user!

  before_action :set_record, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[show edit update destroy]

  before_action :set_record_items, only: %i[new edit show]
  before_action :build_record_values, only: %i[edit]

  def index
    @records = current_user.records.order(recorded_date: :desc)
    @date = params[:date]&.to_date || Date.current

    @record = current_user.records
                          .includes(:record_values, :activities)
                          .find_or_initialize_by(recorded_date: @date)

    @activities = @record.persisted? ? @record.activities : Activity.none

    set_current_time
  end

  def show
    @activities = @record.activities
  end

  def new
    @record = current_user.records.new(
      recorded_date: params[:date]
    )

    RecordValuesBuilder.new(@record, current_user).call
  end

  def edit
  end

  def create
    @record = current_user.records.build(processed_record_params)

    if @record.save
      redirect_to records_path, notice: "記録を保存しました"
    else
      set_record_items
      RecordValuesBuilder.new(@record, current_user).call
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @record.update(processed_record_params)
      redirect_to @record, notice: "記録を更新しました。"
    else
      set_record_items
      RecordValuesBuilder.new(@record, current_user).call
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @record.destroy!
    redirect_to records_url, notice: "記録を削除しました。", status: :see_other
  end

  def create_with_activity
    date = params[:date]

    record = current_user.records.find_or_create_by!(
      recorded_date: date
    )

    redirect_to new_record_activity_path(
      record,
      date: date,
      hour: params[:hour]
    )
  end

  private

  def set_record
    @record = current_user.records.find(params[:id])
  end

  def authorize_user!
    return if @record.user_id == current_user.id

    redirect_to records_path, alert: "アクセス権限がありません。"
  end

  def set_record_items
    @record_items = current_user.record_items
                                .where(is_default_visible: true)
                                .order(:display_order)
  end

  def build_record_values
    RecordValuesBuilder.new(@record, current_user).call
  end

  def processed_record_params
    RecordTimeRangeBuilder.new(record_params).call
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
