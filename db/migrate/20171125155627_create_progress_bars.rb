class CreateProgressBars < ActiveRecord::Migration
  def change
    create_table :progress_bars do |t|
      t.text    :message
      t.integer :percent
      t.integer :user_id
      t.timestamps null: false
    end
    add_index :progress_bars, :user_id
  end
end
