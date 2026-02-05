# frozen_string_literal: true

Rails.logger.debug "テストユーザーを作成します"
user = User.find_or_create_by!(email: 'test@example.com') do |u|
  u.password = 'password'
  u.password_confirmation = 'password'
end
Rails.logger.debug { "ユーザー作成完了: #{user.email}" }

Rails.logger.debug "system record_items を投入します"

default_items = [
  {
    name: "睡眠時間",
    input_type: :time_range,
    category: :default,
    display_order: 1
  },
  {
    name: "気分",
    input_type: :five_step,
    category: :default,
    display_order: 2
  },
  {
    name: "体調",
    input_type: :five_step,
    category: :default,
    display_order: 3
  },
  {
    name: "意欲",
    input_type: :five_step,
    category: :default,
    display_order: 4
  },
  {
    name: "疲労感",
    input_type: :five_step,
    category: :default,
    display_order: 5
  }
]

default_items.each do |item_attrs|
  RecordItem.find_or_create_by!(
    name: item_attrs[:name],
    user: user
  ) do |item|
    item.input_type = item_attrs[:input_type]
    item.category = item_attrs[:category]
    item.display_order = item_attrs[:display_order]
    item.item_type = :system
  end
end

Rails.logger.debug "OK!"
