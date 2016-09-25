class CreateFeats < ActiveRecord::Migration[5.0]
  def change
    create_table :feats do |t|
      t.references :match, index: true
      t.references :player, index: true
      t.string :kind
      t.string :casuality
      t.boolean :host_team, default: false
      t.integer :dice_roll
      t.boolean :level_up, default: false

      t.timestamps
    end
  end
end
