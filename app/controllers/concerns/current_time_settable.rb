# frozen_string_literal: true

module CurrentTimeSettable
  extend ActiveSupport::Concern

  def set_current_time
    @current_hour = Time.current.hour
    @current_minute = Time.current.min
  end
end
