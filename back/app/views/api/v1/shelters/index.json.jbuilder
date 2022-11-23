json.success true

json.shelter do
  json.city_name @prefecture.name + @city.name if @prefecture.present? && @city.present?
  json.total_count @shelters.total_count
  json.current_page @shelters.current_page
  json.total_pages @shelters.total_pages
  json.limit_value @shelters.limit_value
end

json.shelters do
  json.array! @shelters do |shelter|
    json.id shelter.id
    json.name shelter.name
    json.address shelter.address
    json.flood shelter.flood
    json.landslide shelter.landslide
    json.storm_surge shelter.storm_surge
    json.earthquake shelter.earthquake
    json.tsunami shelter.tsunami
    json.fire shelter.fire
    json.inland_flood shelter.inland_flood
    json.volcano shelter.volcano
    json.duplicate shelter.duplicate
    json.latitude shelter.latitude
    json.longitude shelter.longitude
    json.remark shelter.remark
  end
end
