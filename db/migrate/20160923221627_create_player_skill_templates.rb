class CreatePlayerSkillTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :player_skill_templates do |t|
      t.references :player_template, index: true
      t.references :skill_template, index: true

      t.timestamps
    end
  end
end
