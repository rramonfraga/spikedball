class CreateStartPlayerTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :start_player_teams do |t|
      t.references :start_player, index: true
      t.references :team_template, index: true

      t.timestamps
    end
  end
end
