class CreateCounters < ActiveRecord::Migration[5.2]
  def change
    create_table :counters do |t|
      t.integer :user_id
      t.integer :count_id
      t.boolean :main
      t.timestamps null: false
    end
  end
end
