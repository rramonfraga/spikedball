class CreateSkillTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :skill_templates do |t|
      t.string  :name
      t.string  :category
      t.text    :description

      t.timestamps
    end
  end
end
