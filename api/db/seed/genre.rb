Genre.create!(
  id: 1,
  name: '電気・ガス',
  image: File.open("#{Rails.root}/public/images/genre/electric.jpeg")
)
Genre.create!(
  id: 2,
  name: '水道',
  image: File.open("#{Rails.root}/public/images/genre/water.jpeg")
)
Genre.create!(
  id: 3,
  name: '応急',
  image: File.open("#{Rails.root}/public/images/genre/kit.jpeg")
)
Genre.create!(
  id: 4,
  name: '知恵',
  image: File.open("#{Rails.root}/public/images/genre/knowledge.jpeg")
)
Genre.create!(
  id: 5,
  name: '地震',
  image: File.open("#{Rails.root}/public/images/genre/earthquake.jpeg")
)
Genre.create!(
  id: 6,
  name: '津波',
  image: File.open("#{Rails.root}/public/images/genre/tsunami.jpeg")
)
Genre.create!(
  id: 7,
  name: '火山噴火',
  image: File.open("#{Rails.root}/public/images/genre/volcano.jpeg")
)
Genre.create!(
  id: 8,
  name: '大雪',
  image: File.open("#{Rails.root}/public/images/genre/snow.jpeg")
)
Genre.create!(
  id: 9,
  name: '台風',
  image: File.open("#{Rails.root}/public/images/genre/typhoon.jpeg")
)
Genre.create!(
  id: 10,
  name: '内水氾濫',
  image: File.open("#{Rails.root}/public/images/genre/internalwater.jpeg")
)
Genre.create!(
  id: 11,
  name: '河川洪水',
  image: File.open("#{Rails.root}/public/images/genre/flood.jpeg")
) 
Genre.create!(
  id: 12,
  name: '土砂災害',
  image: File.open("#{Rails.root}/public/images/genre/landslide.jpeg")
) 
Genre.create!(
  id: 13,
  name: '強風',
  image: File.open("#{Rails.root}/public/images/genre/strongwind.jpeg")
)
Genre.create!(
  id: 14,
  name: '熱中症',
  image: File.open("#{Rails.root}/public/images/genre/heatstroke.jpeg")
)
Genre.create!(
  id: 15,
  name: '防災情報',
  image: File.open("#{Rails.root}/public/images/genre/disaster_prevention.jpeg")
)
Genre.create!(
  id: 16,
  name: '国民保護情報',
  image: File.open("#{Rails.root}/public/images/genre/jalert.jpeg")
)
