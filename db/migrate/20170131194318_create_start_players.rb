class CreateStartPlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :start_players do |t|
      t.string :name
      t.integer :cost
      t.integer :ma
      t.integer :st
      t.integer :ag
      t.integer :av
      t.boolean :feeder

      t.timestamps
    end
  end
end
