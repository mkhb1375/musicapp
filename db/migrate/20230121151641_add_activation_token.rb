class AddActivationToken < ActiveRecord::Migration[7.0]
  def change
  end
  add_column :users , :activation_token , :string , presence:true
end
