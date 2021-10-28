class CreateExamWindows < ActiveRecord::Migration[6.1]
  def change
    create_table :exam_windows do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
