class TracksController < ApplicationController
    before_action :require_user
    before_action :track_id2_permission , only: %i(new)
    before_action :track_id_permission , only: %i(create)
    before_action :track_permission , except: %i(show create new)

    def show

        @track = Track.find_by(id:params[:id])
        @album = @track.band_album
        @band = @track.band_album.band

        if @album.cover.persisted?

            @cover = url_for(@album.cover)
            @height = @album.cover_height
        end

        render :show
    end


    def new
        flash[:code2] = params[:band_album_id]
        @track = Track.new(album_id:params[:band_album_id])
        @album = @track.band_album
        @albums = BandAlbum.where("band_id = ?", @track.band_album.band.id)
        @band = @track.band_album.band
        
        # @albums = BandAlbum.all
        render :new
    end


    def create 

        @track =  Track.new(
          title:  params[:track][:title] ,
          ord:  params[:track][:ord] ,
          track_type:  params[:track][:track_type] ,
          lyrics:  params[:track][:lyrics] ,
          album_id: flash[:code2],
          music: params[:track][:music]

        )

        if @track.save 

            flash[:notice] = ["Track Created"]
            redirect_to band_album_url(@track.album_id)
        
    else

        flash[:notice] = @track.errors.full_messages
        redirect_to new_band_album_track_url(@track.album_id)

        end

    end


    def edit

        @track = Track.find_by(id:params[:id])
        @album = @track.band_album
        @band = @track.band_album.band
        @albums = BandAlbum.where("band_id= ?", @track.band_album.band.id)
        render :edit
    end


    def update

        @track = Track.find_by(id:params[:id])

        if @track.update(track_params)

            flash[:notice] = ["Track Updated"]
            redirect_to track_url(@track)
        
    else

        flash[:notice] = @track.errors.full_messages
        redirect_to edit_track_url(@track)

        end

    end


    def destroy

        @track = Track.find_by(id:params[:id])
        @id = @track.band_album.id
        @track.destroy
        redirect_to band_album_url(@id)

    end


private   

    def track_params

        params.require(:track).permit(:title , :ord  ,:track_type ,:lyrics , :music)

    end

end