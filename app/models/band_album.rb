class BandAlbum < ApplicationRecord
    validates :title , :year , :band_id  , :album_type , presence:true
    validates :year   , numericality: { in: 1860...(Time.now.year) }
    
    belongs_to :band 
    


    has_one_attached:cover
    validate :cover_format
    

    def cover_height
        cover.metadata['height']
    end
    
    def cover_width
        cover.metadata['width']
    end

    has_many :tracks , 
    -> { order(ord: :asc) },
    class_name: 'Track' ,
    foreign_key: :album_id ,
    dependent: :destroy

    private

    

    def cover_format
        return unless cover.attached?
        if cover.blob.content_type.start_with? 'image/'
            if cover.blob.byte_size > 2.megabytes
            errors.add(:cover, 'size needs to be less than 2MB')
            cover.purge
            end    

        else
            cover.purge
            errors.add(:cover, 'needs to be an image')
        end
    end

    

end
