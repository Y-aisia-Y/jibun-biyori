# frozen_string_literal: true

class CalendarsController < ApplicationController
  before_action :authenticate_user!

  def show
    # simple_calendarが月移動に使うパラメータ
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.current

    # その月の記録をすべて取得
    @calendar_records = current_user.records.where(
      recorded_date: @start_date.all_month
    )

    # 下部のサマリーに表示する日付（クリックした日、なければ今日）
    @selected_date = params[:date] ? Date.parse(params[:date]) : Date.current
    @selected_record = current_user.records.find_by(recorded_date: @selected_date)
  end
end
