json.success true

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
