class CreateUserCommunities < ActiveRecord::Migration[5.0]
  def change
    create_table :user_communities do |t|
      t.references :user, index: true
      t.references :community, index: true
      t.boolean :admin, default: false


      t.timestamps
    end
  end
end
