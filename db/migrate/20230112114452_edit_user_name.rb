class EditUserName < ActiveRecord::Migration[7.0]
  def change
  end
  change_column :users , :name, :string , null:false 
end
