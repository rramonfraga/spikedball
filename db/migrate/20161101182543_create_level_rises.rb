class CreateLevelRises < ActiveRecord::Migration[5.0]
  def change
    create_table :level_rises do |t|
      t.integer :first_dice
      t.integer :second_dice
      t.string :title
      t.string :characteristic
      t.integer :value
      t.references :player,  index: true
      t.references :skill,   index: true

      t.timestamps
    end
  end
end
