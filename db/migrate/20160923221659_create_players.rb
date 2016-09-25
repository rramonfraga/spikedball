class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.references :team, index: true
      t.string  :title
      t.string  :name
      t.references :player_template, index: true
      t.integer :dorsal
      t.integer :cost
      t.integer :experience, default: 0
      t.string  :level, default: "Rookie"
      t.boolean :level_up, default: false
      t.integer :mvp
      t.integer :ma
      t.integer :st
      t.integer :ag
      t.integer :av

      t.timestamps
    end
  end
end
