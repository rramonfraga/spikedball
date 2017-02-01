class AddFireToPlayer < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :fire, :boolean, default: false
    add_column :players, :freelance, :boolean, default: false
    add_column :player_templates, :freelance, :boolean, default: false
  end
end
