json.success true
json.comments do
  json.array! @comments do |comment|
    json.id comment.id
    json.content comment.content
    json.created_at comment.created_at
    json.updated_at comment.updated_at
  end
end
