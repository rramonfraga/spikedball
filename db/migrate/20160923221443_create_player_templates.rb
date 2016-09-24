class CreatePlayerTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :player_templates do |t|
      t.integer :quantity
      t.string :title
      t.references :team_template, index: true
      t.integer :cost
      t.integer :ma
      t.integer :st
      t.integer :ag
      t.integer :av
      t.string :normal
      t.string :double
      t.boolean :feeder

      t.timestamps
    end
  end
end
