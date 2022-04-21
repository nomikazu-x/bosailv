json.infomations do
  json.array! @infomations do |infomation|
    json.title infomation.title
    json.body infomation.body
    json.started_at infomation.started_at
    json.ended_at infomation.ended_at
    json.target infomation.target
  end
end
