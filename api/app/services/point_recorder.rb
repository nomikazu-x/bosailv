# ポイントに関する計算を行い、保存する
class PointRecorder
  def initialize(user)
    @user = user
  end

  def record(obtained_point)
    point_record = @user.point_records.build(obtained_point: obtained_point)

    if point_record.persisted?
      down_check = true # 経験値が減っている可能性があることを示す
    end

    if point_record.save!
      @user.total += obtained_point
      check_level_down if down_check
      check_level
      @user.save!
      point_record
    end
  end

  # 獲得ポイントに関連することが削除されたときに経験値を減らす
  def delete_record(obtained_point)
    point_record = @user.point_records.find_by(obtained_point: obtained_point)
    point = point_record.obtained_point
    @user.total -= point
    check_level_down
    check_level
    @user.save!
    point_record.destroy!
  end

  private

  def check_level
    required = RequiredPoint.find_by(level: @user.level)
    # 次のレベルに必要な経験値 - 獲得した経験値
    sub_total = required.lifelong_point - @user.total
    # 100を上限とする
    if @user.level < 99
      if sub_total <= 0
        @user.level += 1
        check_level # 再帰的に処理
      else
        @user.to_next = sub_total
      end
    elsif @user.level == 99
      if sub_total <= 0
        @user.level += 1
        @user.to_next = 0
      else
        @user.to_next = sub_total
      end
    end
  end

  def check_level_down
    required = RequiredPoint.find_by(level: @user.level - 1)
    if required
      sub_total = required.lifelong_point - @user.total
      if sub_total >= 0
        @user.level -= 1
        check_level_down # 再帰的に処理
      end
    end
  end
end