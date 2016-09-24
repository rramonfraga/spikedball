class CreatePlayerSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :player_skills do |t|
      t.references :player, index: true
      t.references :skill_template, index: true

      t.timestamps
    end
  end
end
