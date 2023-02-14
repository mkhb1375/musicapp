class User < ApplicationRecord
    
    validates :active? , presence:true , numericality: { in: 0..2 }
    validates :activation_token , presence:true 
    validates :email , presence:true , uniqueness:true , email:true
    validates :password_digest , :name ,presence:true
    validates :password , length:{minimum:8,allow_nil:true,message: ' is to short , minimum characters is 8 '}
    validates :session_token , presence:true , uniqueness:true
    validate :ensure_session_token
    attr_reader :password

    has_many :bands ,
    -> { order(created_at: :asc) },
    foreign_key: :user_id ,
    dependent: :destroy

    has_one_attached:image

    def self.generate_session_token

        SecureRandom.urlsafe_base64(16)

    end

    def self.find_by_credentials(email,password)

        user = User.find_by(email:email)
        return nil unless user &&  BCrypt::Password.new(user.password_digest).is_password?(password)
        user
    end

    def password= (password)

        @password = password 
        self.password_digest = BCrypt::Password.create(password)

    end

    def reset_session_token!

        self.session_token = User.generate_session_token
        self.save
        self.session_token

    end

    def songs

        count = 0
        self.bands.each do |band|
            
            band.band_albums.each do |album|

                album.tracks.each do |song|
                    
                    count +=1
                    
                end


            end

        end
        return count

    end
    
    private
    def ensure_session_token

        self.session_token ||= User.generate_session_token

    end



end
