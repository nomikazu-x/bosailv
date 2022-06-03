#次のレベルに必要な経験値算出
sum = 0
pre = 0
100.times do |i|
  i += 1
  if i == 1
    point = 5
  else i <= 20
    point = 5 + i * 2
  end
  point = point.round
  sum += point
  puts "#{i}レベル 次のレベルに必要な経験値: #{point} 累計: #{sum}"
  pre = point

  RequiredPoint.create!(level: i, required_point: point, lifelong_point: sum)
end