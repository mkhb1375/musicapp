class ApplicationController < ActionController::Base
    helper_method :any_user? , :current_user , :band_view , :album_view , :track_view
     
    private


    def current_user
        @current_user ||=User.find_by(session_token: session[:session_token])
        
    end

    def any_user?

        return true if current_user
        false

    end

    def require_user

      redirect_to new_user_url unless any_user?

    end

    def requiere_no_user

        redirect_to user_url(current_user.id) if any_user?

    end

    def band_permission


        redirect_to "/bands" unless current_user.bands.include?(Band.find_by(id:params[:id]))

    end

    def band_view


        current_user.bands.include?(Band.find_by(id:params[:id]))

    end

    def band_id_permission


        redirect_to "/bands" unless current_user.bands.include?(Band.find_by(id:flash[:code]))

    end


    def band_id2_permission


        redirect_to "/bands" unless current_user.bands.include?(Band.find_by(id:params[:band_id]))

    end
       

    def albums_permission


        redirect_to "/bands" unless current_user.bands.include?(BandAlbum.find_by(id:params[:id]).band)

    end

    def album_view


         current_user.bands.include?(BandAlbum.find_by(id:params[:id]).band)

    end

    def track_permission


        redirect_to "/bands" unless current_user.bands.include?(Track.find_by(id:params[:id]).band_album.band)

    end


    def track_view


       current_user.bands.include?(Track.find_by(id:params[:id]).band_album.band)

    end

    def track_id_permission


        redirect_to "/bands" unless current_user.bands.include?(BandAlbum.find_by(id:flash[:code2]).band)

    end

    def track_id2_permission


        redirect_to "/bands" unless current_user.bands.include?(BandAlbum.find_by(id:params[:band_album_id]).band)

    end

end
