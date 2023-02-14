class AddActiveToUser < ActiveRecord::Migration[7.0]
  def change

  end
  add_column :users , :active? , :integer , null:false 
  
   
end
