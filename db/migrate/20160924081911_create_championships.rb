class CreateChampionships < ActiveRecord::Migration[5.0]
  def change
    create_table :championships do |t|
      t.string :name
      t.references :community, index: true
      t.string :kind, default: "League"
      t.integer :init_treasury, default: 1000000
      t.boolean :start, default: false
      t.boolean :finish, default: false

      t.timestamps
    end
  end
end
