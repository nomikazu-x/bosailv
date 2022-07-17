# == Schema Information
#
# Table name: tasks
#
#  id              :bigint           not null, primary key
#  body(本文)      :text(4294967295) not null
#  summary(概要)   :string(50)       not null
#  title(タイトル) :string(30)       not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "correct_task" do
    let(:task) { build(:task) }

    it "タスクが正しく作成されていること" do
      expect(task).to be_valid
    end
  end

  describe "validate length" do
    context "titleの長さが31文字以上の時" do
      let(:task) { build(:task, title: 'a' * 31) }
      it "エラーメッセージが返る" do
        task.valid?
        expect(task).to be_invalid
      end
    end

    context "summaryの長さが31文字以上の時" do
      let(:task) { build(:task, summary: 'a' * 51) }
      it "エラーメッセージが返る" do
        task.valid?
        expect(task).to be_invalid
      end
    end
  end

  describe "validate presence" do
    context "titleがNULLの時" do
      let(:task) { build(:task, title: nil) }
      it "エラーメッセージが返る" do
        task.valid?
        expect(task).to be_invalid
      end
    end

    context "imageがNULLの時" do
      let(:task) { build(:task, image: nil) }
      it "エラーメッセージが返る" do
        task.valid?
        expect(task).to be_invalid
      end
    end

    context "summaryがNULLの時" do
      let(:task) { build(:task, summary: nil) }
      it "エラーメッセージが返る" do
        task.valid?
        expect(task).to be_invalid
      end
    end

    context "bodyがNULLの時" do
      let(:task) { build(:task, body: nil) }
      it "エラーメッセージが返る" do
        task.valid?
        expect(task).to be_invalid
      end
    end
  end

  describe "association" do
    it "TaskCompleteテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:task_completes)
      expect(rel.macro).to eq :has_many
    end
  end
end
