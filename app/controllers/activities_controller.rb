# frozen_string_literal: true

class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record
  before_action :set_activity, only: %i[show edit update destroy]

  def index
    @activities = @record.activities.order(start_time: :asc).decorate
  end

  def show; end

  def new
    @activity = @record.activities.build
    assign_default_times if params[:hour].present?
  end

  def edit; end

  def create
    @activity = @record.activities.build(activity_params)

    if @activity.save
      redirect_to dashboard_path(date: @record.recorded_date), success: t('.success')
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @activity.update(activity_params)
      redirect_to dashboard_path(date: @record.recorded_date), success: t('.success')
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @activity.destroy!
    redirect_to dashboard_path(date: @record.recorded_date), danger: t('.success')
  rescue ActiveRecord::RecordNotDestroyed
    redirect_to edit_record_activity_path(@record, @activity), warning: t('.failure')
  end

  def activity_params
    attrs = params.require(:activity).permit(
      :content,
      :start_date, :start_hour, :start_minute,
      :end_date, :end_hour, :end_minute
    )
    attrs[:start_time] = build_time(attrs, :start)
    attrs[:end_time]   = build_time(attrs, :end)
    attrs.slice(:content, :start_time, :end_time)
  end

  private

  def assign_default_times
    date = params[:date] || @record.recorded_date
    @activity.start_time = Time.zone.parse("#{date} #{params[:hour]}:00")
    @activity.end_time = @activity.start_time + 1.hour
  end

  def set_record
    @record = current_user.records.find(params[:record_id])
  end

  def set_activity
    @activity = @record.activities.find(params[:id])
  end

  def build_time(attrs, prefix)
    date = attrs["#{prefix}_date"]
    hour = attrs["#{prefix}_hour"]
    min  = attrs["#{prefix}_minute"]

    return nil if date.blank?

    Time.zone.parse("#{date} #{hour}:#{min}")
  end
end
