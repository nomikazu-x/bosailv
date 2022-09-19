json.success true

json.hazard_map do
  json.id @hazard_map.city_id
  json.city_name @city_name
  json.tsunami @hazard_map.tsunami
  json.flood @hazard_map.flood
  json.landslide @hazard_map.landslide
  json.inland_flood @hazard_map.inland_flood
  json.storm_surge @hazard_map.storm_surge
  json.volcano @hazard_map.volcano
  json.reservoir @hazard_map.reservoir
end
