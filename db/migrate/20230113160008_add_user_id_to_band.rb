class AddUserIdToBand < ActiveRecord::Migration[7.0]
  def change
  end
  add_column :bands , :user_id , :integer , null:false
  add_index :bands , :user_id
end
