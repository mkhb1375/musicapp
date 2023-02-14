class AddConstraint < ActiveRecord::Migration[7.0]
  
  add_check_constraint :band_albums, "album_type IN ('Live' , 'Studio')", name: "album_type_check"
end