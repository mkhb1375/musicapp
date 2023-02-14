class Track < ApplicationRecord

    validates :title , :ord , :track_type ,:album_id , presence:true
     validates :ord ,numericality: { in: 0..10000 }
    belongs_to :band_album ,
    class_name: 'BandAlbum' ,
    foreign_key: :album_id

    has_one_attached:music
    validate :music_format


    private 


    def music_format 

        return unless music.attached?

        if music.blob.content_type.start_with? 'audio/'

            if music.blob.byte_size > 30.megabytes
                errors.add(:music, 'size needs to be less than 30MB')
                music.purge
            end 


         else
            music.purge
            errors.add(:music, 'needs to be an audio file')
        end

    end

end