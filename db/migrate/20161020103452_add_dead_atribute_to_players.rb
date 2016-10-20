class AddDeadAtributeToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :dead, :boolean, default: false
  end
end
