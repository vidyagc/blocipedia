class AddCidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cid, :string
  end
end
