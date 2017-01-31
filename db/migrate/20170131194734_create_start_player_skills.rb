class CreateStartPlayerSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :start_player_skills do |t|
      t.references :start_player, index: true
      t.references :skill_template, index: true

      t.timestamps
    end
  end
end
