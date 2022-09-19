Genre.create!(
  id: 1,
  name: '電気・ガス',
  description: '災害が起きた時、電気やガスが停止した時のために備えましょう。電気・ガスの停止したときの備えやガスメーターの復帰方法を確認しましょう。',
  icon: 'mdi-fuel',
  image: File.open("#{Rails.root}/public/images/genre/image/electric.jpeg")
)
Genre.create!(
  id: 2,
  name: '水道',
  description: '災害が起きた時、水道が停止した時のための備えが大切です。飲料水・生活用水の確保を考えておきましょう。',
  icon: 'mdi-water-pump',
  image: File.open("#{Rails.root}/public/images/genre/image/water.jpeg")
)
Genre.create!(
  id: 3,
  name: '応急',
  description: '災害が起きた時、自分や周りの人が怪我をしたり、すぐに救助できないこともあります。緊急時に役立つ応急手当の知識を確認しましょう。',
  icon: 'mdi-medical-bag',
  image: File.open("#{Rails.root}/public/images/genre/image/kit.jpeg")
)
Genre.create!(
  id: 4,
  name: '知恵',
  description: '災害が起きた時に、ライフラインはすべてストップし、必要な物が手に入らない場合、そんな災害発生時に役立つさまざまな「知恵」を確認しましょう。',
  icon: 'mdi-lightbulb-on',
  image: File.open("#{Rails.root}/public/images/genre/image/knowledge.jpeg")
)
Genre.create!(
  id: 5,
  name: '地震',
  description: '「地震発生～直後」にどう行動すれば良いか、「避難」の判断の仕方や地震の「知識や備え」など、とるべき行動をあらかじめ確認しておきましょう。',
  icon: 'mdi-image-broken-variant',
  image: File.open("#{Rails.root}/public/images/genre/image/earthquake.jpeg")
)
Genre.create!(
  id: 6,
  name: '津波',
  description: '地震があったら「津波」の発生が考えられます。大津波警報・津波警報・津波注意報が発表された場合はすぐに高台などへ避難しましょう。',
  icon: 'mdi-tsunami',
  image: File.open("#{Rails.root}/public/images/genre/image/tsunami.jpeg")
)
Genre.create!(
  id: 7,
  name: '火山噴火',
  description: '「火山」が噴火すると大きな災害を引き起こします。噴火警戒レベルを知り、警報を入手できるようにしたり、ハザードマップを確認しておきましょう。',
  icon: 'mdi-volcano',
  image: File.open("#{Rails.root}/public/images/genre/image/volcano.jpeg")
)
Genre.create!(
  id: 8,
  name: '大雪',
  description: '「大雪」が予想されているときには、基本的には不要な外出は控えましょう。気象情報や周囲の状況に注意し、危険を感じた場合にはすぐに身の安全を図る行動をとりましょう。',
  icon: 'mdi-snowflake',
  image: File.open("#{Rails.root}/public/images/genre/image/snow.jpeg")
)
Genre.create!(
  id: 9,
  name: '台風',
  description: '「台風」へのそなえは上陸する前に行いましょう。気象条件によっては、台風が日本列島に接近する前から大雨になり、広範囲で災害を引き起こす大雨になることもあります。',
  icon: 'mdi-weather-hurricane',
  image: File.open("#{Rails.root}/public/images/genre/image/typhoon.jpeg")
)
Genre.create!(
  id: 10,
  name: '内水氾濫',
  description: '「内水氾濫」とは、市街地などに短時間で局地的な大雨が降り、下水道や排水路が水をさばききれなくなり、あふれだした雨水が建物や土地、道路などを水浸しにすることです。',
  icon: 'mdi-home-flood',
  image: File.open("#{Rails.root}/public/images/genre/image/internalwater.jpeg")
)
Genre.create!(
  id: 11,
  name: '河川洪水',
  description: '「河川洪水・氾濫」の予兆は大雨や長雨です。大雨の気象警報・注意報が発表されたら河川に近づいてはいけません。',
  icon: 'mdi-home-flood',
  image: File.open("#{Rails.root}/public/images/genre/image/flood.jpeg")
) 
Genre.create!(
  id: 12,
  name: '土砂災害',
  description: '「土砂災害」は、大雨や集中豪雨、地震が原因となることが多く、突発的に発生します。土砂災害警戒情報を知り、ハザードマップを確認して、自分の家が安全か確認しておきましょう。',
  icon: 'mdi-landslide',
  image: File.open("#{Rails.root}/public/images/genre/image/landslide.jpeg")
) 
Genre.create!(
  id: 13,
  name: '強風',
  description: '天気予報で「雷を伴う」や「竜巻などの激しい突風」という注意喚起があったら強風に注意しましょう。室内では雨戸やカーテンを閉め、窓から離れましょう。',
  icon: 'mdi-weather-windy',
  image: File.open("#{Rails.root}/public/images/genre/image/strongwind.jpeg")
)
Genre.create!(
  id: 14,
  name: '熱中症',
  description: '熱中症は水分・塩分補給などの予防が肝心です。気温が高くなりそうな日は注意をし、熱中症の症状が出てしまった時は適切な応急処置をしましょう。',
  icon: 'mdi-weather-sunny-alert',
  image: File.open("#{Rails.root}/public/images/genre/image/heatstroke.jpeg")
)
Genre.create!(
  id: 15,
  name: '防災情報',
  description: '災害時、特に大雨の際は、自治体からの避難情報のほか、土砂災害警戒情報や特別警報などたくさんの防災情報が発表されます。正しく理解し使いこなして避難行動に役立てましょう。',
  icon: 'mdi-alert',
  image: File.open("#{Rails.root}/public/images/genre/image/disaster_prevention.jpeg")
)
Genre.create!(
  id: 16,
  name: '国民保護情報',
  description: '国民保護情報とはなにか、発生後にどう行動すれば良いか、避難場所やそなえるべきポイントを確認しましょう。アラート等で情報を受け取った際に慌てないように知っておきましょう。',
  icon: 'mdi-alert',
  image: File.open("#{Rails.root}/public/images/genre/image/jalert.jpeg")
)
