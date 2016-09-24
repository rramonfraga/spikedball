class CreateTeamTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :team_templates do |t|
      t.string :name
      t.text :description
      t.integer :re_roll
      t.boolean :apothecary
      t.boolean :stakes
      t.string :revive

      t.timestamps
    end
  end
end
