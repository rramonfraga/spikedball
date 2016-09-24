class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.references :user, index: true
      t.string :name
      t.references :team_template, index: true
      t.integer :treasury, default: 1000000
      t.integer :value
      t.integer :re_rolls
      t.integer :fan_factor
      t.integer :assistant_coaches
      t.integer :cheerleaders
      t.integer :apothecaries
      t.integer :halfling_chef

      t.timestamps
    end
  end
end
