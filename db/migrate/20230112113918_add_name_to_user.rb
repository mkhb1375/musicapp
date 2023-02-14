class AddNameToUser < ActiveRecord::Migration[7.0]
  def change
  end
  add_column :users , :name , :string
end
