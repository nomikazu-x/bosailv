json.success true

json.prefectures do
  json.array! @prefectures do |prefecture|
    json.id prefecture.id
    json.name prefecture.name
  end
end
