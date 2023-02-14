class ConfirmsController < ApplicationController

    def show

        if request.original_url.to_s.include?("/bands/")

            
            @band = Band.find_by(id:params[:band_id])
            @url = band_url(@band)
            @message = "Are you sure you want to delete Band:"
            @name = @band.name
        end

        if request.original_url.to_s.include?("/band_albums/")

            
            @band = BandAlbum.find_by(id:params[:band_album_id])
            @url = band_album_url(@band)
            @message = "Are you sure you want to delete Album:"
            @name = @band.title
        end

        if request.original_url.to_s.include?("/tracks/")

            
            @band = Track.find_by(id:params[:track_id])
            @url = track_url(@band)
            @message = "Are you sure you want to delete Track:"
            @name = @band.title
        end

        if request.original_url.to_s.include?("/users/")

            
            @band = User.find_by(id:params[:user_id])
            @url = user_url(@band)
            @message = "Are you sure you want to delete User:"
            @name = @band.name
        end


        
        :show

    end

end