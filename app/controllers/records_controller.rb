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
    @record = current_user.records.build(recorded_date: Date.today)
  end

  def create
    @record = current_user.records.build(record_params)

    if @record.save
      redirect_to @record, notice: '記録を作成しました。'
    else
      flash.now[:alert] = '記録の作成に失敗しました。入力内容を確認してください。'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @record.update(record_params)
      redirect_to @record, notice: '記録を更新しました。'
    else
      flash.now[:alert] = '記録の更新に失敗しました。入力内容を確認してください。'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @record.destroy!
    redirect_to records_url, notice: '記録を削除しました。', status: :see_other
  end


  private


  def set_record
    @record = current_user.records.find_by!(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to records_url, alert: '指定された記録が見つからないか、アクセス権限がありません。'
  end

  def check_user
    unless @record.user_id == current_user.id
      redirect_to records_url, alert: '他のユーザーの記録は操作できません。'
    end
  end

  def record_params
    params.require(:record).permit(:recorded_date, :diary_memo)
  end
end
