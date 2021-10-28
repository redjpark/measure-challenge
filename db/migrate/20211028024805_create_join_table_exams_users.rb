class CreateJoinTableExamsUsers < ActiveRecord::Migration[6.1]
  def change
    create_join_table :exams, :users do |t|
      # t.index [:exam_id, :user_id]
      # t.index [:user_id, :exam_id]
    end
  end
end
