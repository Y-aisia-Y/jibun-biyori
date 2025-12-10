# 記録項目の初期データ
puts 'Destroying existing RecordItems...'

RecordItem.destroy_all
TYPES = RecordItem::InputType

# 初期レコード項目を定義
initial_items = [
  {
    name: '睡眠時間',
    input_type: TYPES::NUMBER,
    is_default_visible: true,
  },
  {
    name: '気分',
    input_type: TYPES::SELECT,
    is_default_visible: true,
  },
  {
    name: '意欲',
    input_type: TYPES::RATING,
    is_default_visible: true,
  },
  {
    name: '疲労感',
    input_type: TYPES::RATING,
    is_default_visible: true,
  },
  {
    name: 'メモ',
    input_type: TYPES::TEXT,
    is_default_visible: false,
  }
]

initial_items.each do |item_data|
  RecordItem.create!(item_data)
end

puts "Created #{RecordItem.count} RecordItems."
