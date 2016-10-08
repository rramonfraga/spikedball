class AddInjuriesToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :miss_next_game, :boolean, default: false
    add_column :players, :niggling_injury, :integer, default: 0
  end
end
