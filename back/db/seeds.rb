require 'csv'

# # CSV読み込み
# file_path = 'lib/自治体.csv'
# csv_data = CSV.read(file_path)

# # 都道府県データ抽出
# prefectures_list = csv_data.map { |row| row[1] }.uniq

# # 市区町村データ抽出
# cities_list = csv_data.map do |row|
#   next if row[2] == nil
#   row[0..2]
# end.compact

# # 都道府県データ作成
# prefectures_list.each do |prefecture|
#   Prefecture.create!(name: prefecture)
#   p "Create: #{prefecture}"
# end

# # 市区町村データ作成
# cities_list.each do |id, prefecture, city|
#   prefecture = Prefecture.find_by(name: prefecture)
#   prefecture.cities.create(id: id, name: city)
#   p "Create: #{id} #{city}"
# end

# common_table_name = %w(genre required_point stock)
# common_table_name.each do |table_name|
#   path = Rails.root.join('db', 'seed', "#{table_name}.rb")
#   if File.exist?(path)
#     p "Creating #{table_name}....."
#     require(path)
#   end
# end

# # CSV読み込み
# file_path = 'lib/hazard_map.csv'
# csv_data = CSV.read(file_path)

# csv_data.map do |row|
#   HazardMap.create!(
#     city_id: row[0],
#     tsunami: row[1],
#     flood: row[2],
#     landslide: row[3],
#     inland_flood: row[4],
#     storm_surge: row[5],
#     volcano: row[6],
#     reservoir: row[7],
#   )
#   p row[0]
# end

# # CSV読み込み
# file_path = 'lib/shelters.csv'
# csv_data = CSV.read(file_path)

# csv_data.map do |row|
#   Shelter.create!(
#     city: City.find_by(name: row[1].gsub(/東京都|北海道|(?:京都|大阪)府|.{2,3}県/, '')),
#     city_name: row[1],
#     name: row[3],
#     address: row[4],
#     flood: row[5].present?,
#     landslide: row[6].present?,
#     storm_surge: row[7].present?,
#     earthquake: row[8].present?,
#     tsunami: row[9].present?,
#     fire: row[10].present?,
#     inland_flood: row[11].present?,
#     volcano: row[12].present?,
#     duplicate: row[13].present?,
#     latitude: row[14],
#     longitude: row[15],
#     remark: row[16]
#   )
#   p row[3]
# end


env_paths = ['', "#{Rails.env}/"]
env_paths.each do |env_path|
  list_file = "#{Rails.root}/db/seed/#{env_path}_list.txt"
  p "list_file: #{list_file}"

  File.open(list_file) do |lists|
    lists.each_line do |list|
      p "list: #{list.chomp}"

      target_model = list.chomp.classify.constantize
      p "target_model: #{target_model}"

      yml_file = "#{Rails.root}/db/seed/#{env_path}#{list.chomp}.yml"
      p "yml_file: #{yml_file}"

      File.open(yml_file) do |file_contents|
        yaml_contents = YAML.safe_load(file_contents)
        count = yaml_contents.count
        p "count: #{count}"

        yaml_contents.each.with_index(1) do |yaml_record, index|
          id = yaml_record['id']
          target = "[#{index}/#{count}] id: #{id}"

          if target_model.find_by(id: id)
            p "#{target} Skip create"
            next
          end

          p "#{target} Create"
          target_model.create!(yaml_record)
        end
      end
    end
  end
end
