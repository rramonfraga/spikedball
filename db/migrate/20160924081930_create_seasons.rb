class CreateSeasons < ActiveRecord::Migration[5.0]
  def change
    create_table :seasons do |t|
      t.references :championship, index: true
      t.integer :round

      t.timestamps
    end
  end
end
