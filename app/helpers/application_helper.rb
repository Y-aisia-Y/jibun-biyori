# frozen_string_literal: true

module ApplicationHelper
  def flash_style_classes(type)
    case type.to_s
    when 'notice', 'success'
      "bg-green-50 text-green-800 border border-green-200"
    when 'alert', 'danger'
      "bg-red-50 text-red-800 border border-red-200"
    when 'warning'
      "bg-yellow-50 text-yellow-800 border border-yellow-200"
    when 'info'
      "bg-blue-50 text-blue-800 border border-blue-200"
    else
      "bg-gray-50 text-gray-800 border border-gray-200"
    end
  end
end
