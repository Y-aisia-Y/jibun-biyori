# frozen_string_literal: true

class CalendarsController < ApplicationController
  before_action :authenticate_user!

  def show
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current
    @selected_date = params[:date].present? ? Date.parse(params[:date]) : Date.current

    @calendar_records = current_user.records.where(
      recorded_date: @start_date.all_month
    )

    @selected_record = current_user.records.find_by(recorded_date: @selected_date)
  end
end
