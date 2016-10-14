class RemoveCasualtyAndAddInjury < ActiveRecord::Migration[5.0]
  def change
    remove_column :feats, :casuality
    add_column :feats, :injury, :string
  end
end
