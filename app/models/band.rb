class Band < ApplicationRecord

    validates :name , presence:true

    has_one_attached :cover
    validate :cover_format

    def cover_height
        cover.metadata['height']
    end
    
    def cover_width
        cover.metadata['width']
    end

    has_many :band_albums ,
    -> { order(year: :asc) },
    dependent: :destroy

    belongs_to :user ,
    foreign_key: :user_id
    

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
