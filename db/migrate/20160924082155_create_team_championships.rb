class CreateTeamChampionships < ActiveRecord::Migration[5.0]
  def change
    create_table :team_championships do |t|
      t.references :team, index: true
      t.references :championship, index: true

      t.timestamps
    end
  end
end
