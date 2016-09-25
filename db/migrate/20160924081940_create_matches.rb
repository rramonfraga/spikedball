class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.references :season, index: true
      t.integer :host_team_id
      t.integer :visit_team_id
      t.integer :host_team_treasury
      t.integer :visit_team_treasury
      t.integer :host_team_fan_factor
      t.integer :visit_team_fan_factor
      t.boolean :finish, default: false
      t.integer :host_result, default: 0
      t.integer :visit_result, default: 0

      t.timestamps
    end
  end
end
