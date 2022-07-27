require 'csv'

# CSV読み込み
file_path = 'lib/hazard_map.csv'
csv_data = CSV.read(file_path)

csv_data.map do |row|
  HazardMap.create(
    code: row[0],
    tsunami: row[1],
    flood: row[2],
    landslide: row[3],
    inland_flood: row[4],
    storm_surge: row[5],
    volcano: row[6],
    reservoir: row[7],
  )
  p row[0]
end

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

# CSV読み込み
file_path = 'lib/自治体.csv'
csv_data = CSV.read(file_path)

# 都道府県データ抽出
prefectures_list = csv_data.map { |row| row[1] }.uniq

# 市区町村データ抽出
cities_list = csv_data.map do |row|
  next if row[2] == nil
  row[0..2]
end.compact

# 都道府県データ作成
prefectures_list.each do |prefecture|
  Prefecture.create!(name: prefecture)
  p "Create: #{prefecture}"
end

# 市区町村データ作成
cities_list.each do |code, prefecture, city|
  prefecture = Prefecture.find_by(name: prefecture)
  prefecture.cities.create(code: code, name: city)
  p "Create: #{code} #{city}"
end


common_table_name = %w(genre required_point)
common_table_name.each do |table_name|
  path = Rails.root.join('db', 'seed', "#{table_name}.rb")
  if File.exist?(path)
    p "Creating #{table_name}....."
    require(path)
  end
end