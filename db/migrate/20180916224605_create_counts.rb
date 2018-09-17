class CreateCounts < ActiveRecord::Migration[5.2]
  def change
    create_table :counts do |t|
      t.integer :number
      t.string :title
      t.string :img
      t.string :main_counter
    end
  end
end
