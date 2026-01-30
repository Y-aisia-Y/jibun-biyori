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
      name: "気分",
      input_type: :five_step,
      category: :default_metric,
      display_order: 2
    },
    {
      name: "体調",
      input_type: :five_step,
      category: :default_metric,
      display_order: 3
    },
    {
      name: "意欲",
      input_type: :five_step,
      category: :default_metric,
      display_order: 4
    },
    {
      name: "疲労感",
      input_type: :five_step,
      category: :default_metric,
      display_order: 5
    }
  ]

system_items.each do |attrs|
    item = RecordItem.find_or_initialize_by(
      user: user,
      name: attrs[:name]
    ) do |i|
      i.is_default_visible = true
    end
    item.item_type = :system
    item.category  = :default
    item.input_type = attrs[:input_type]
    item.display_order = attrs[:display_order]
    item.save!
  end
end

puts "OK!"
