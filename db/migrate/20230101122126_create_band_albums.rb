class CreateBandAlbums < ActiveRecord::Migration[7.0]
  def change
    create_table :band_albums do |t|
      t.integer :band_id , null:false
      t.string :title , null:false
      t.integer :year , null:false
      t.string :album_type ,   null:false

      t.timestamps
    end
    add_index :band_albums , :band_id
  end
end



