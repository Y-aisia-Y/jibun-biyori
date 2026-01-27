puts "system record_items を投入します"

User.find_each do |user|
  system_items = [
    {
      name: "睡眠時間",
      input_type: :time_range,
      category: :default_metric,
      display_order: 1
    },
    {
      name: "体調",
      input_type: :five_step,
      category: :default_metric,
      display_order: 2
    },
    {
      name: "意欲",
      input_type: :five_step,
      category: :default_metric,
      display_order: 3
    },
    {
      name: "疲労感",
      input_type: :five_step,
      category: :default_metric,
      display_order: 4
    }
  ]

  system_items.each do |attrs|
    RecordItem.find_or_create_by!(
      user: user,
      name: attrs[:name]
    ) do |item|
      item.category = "system"
      item.input_type = attrs[:input_type]
      item.unit = attrs[:unit]
      item.display_order = attrs[:display_order]
      item.is_default_visible = true
    end
  end
end

puts "OK!"
