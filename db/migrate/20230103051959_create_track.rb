class CreateTrack < ActiveRecord::Migration[7.0]
  def change
    create_table :tracks do |t|
      t.string  :title , null:false
      t.integer :ord , null:false
      t.text :lyrics 
      t.boolean :track_type , null:false
      t.integer :album_id , null:false
      t.timestamps
    end
    add_index :tracks , :album_id
  end
end
