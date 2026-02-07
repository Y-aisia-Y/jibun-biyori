# frozen_string_literal: true

module Mypage
  class RecordItemSettingsController < ApplicationController
    before_action :authenticate_user!

    def show
      @system_items = current_user.record_items.system_items.ordered
    end
  end
end
