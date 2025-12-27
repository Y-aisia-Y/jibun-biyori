module CurrentTimeSettable
  extend ActiveSupport::Concern

  included do
    before_action :set_current_time, only: %i[index show]
  end

  private

  def set_current_time
    @current_hour = Time.current.hour
    @current_minute = Time.current.min
  end
end
