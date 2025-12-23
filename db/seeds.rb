
puts "デフォルト値投入！"

User.find_each do |user|
  default_items = [
    {
      name: "睡眠時間",
      input_type: :time_range,
      unit: "時間",
      is_default: true,
      display_order: 1
    },
    {
      name: "気分",
      input_type: :five_step,
      is_default: true,
      display_order: 2
    },
    {
      name: "体調",
      input_type: :five_step,
      is_default: true,
      display_order: 3
    },
    {
      name: "意欲",
      input_type: :five_step,
      is_default: true,
      display_order: 4
    },
    {
      name: "疲労感",
      input_type: :five_step,
      is_default: true,
      display_order: 5
    }
  ]

  default_items.each do |attrs|
    RecordItem.find_or_create_by!(
      user: user,
      name: attrs[:name]
    ) do |item|
      item.category = attrs[:category]
      item.input_type = attrs[:input_type]
      item.unit = attrs[:unit]
      item.display_order = attrs[:display_order]
      item.is_default = true
      item.is_default_visible = true
    end
  end
end

puts "OK!"
