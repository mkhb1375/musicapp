class BandAlbumsController < ApplicationController
    before_action :require_user

    before_action :band_id_permission , only: %i(create)
    before_action :band_id2_permission , only: %i(new)
    before_action :albums_permission , except: %i(show create new)

    def show
       
        @albums = BandAlbum.find_by(id:params[:id])

      
        if @albums.cover.persisted?

            @cover = url_for(@albums.cover)
            @width = @albums.cover_width
            @height = @albums.cover_height
        end
        
        @band = @albums.band if @albums
        render :show
    end

    def new
        @album = BandAlbum.new(band_id:params[:band_id],album_type:"Studio")
        @band = @album.band
        @bands = Band.all
        flash[:code] = params[:band_id]
        render :new
       

    end


    def create 

        @album = BandAlbum.new(
            year:params[:band_album][:year] ,
             title:params[:band_album][:title] ,
            album_type:params[:band_album][:album_type] ,
             band_id: flash[:code],
             cover:params[:band_album][:cover] 
            )
        
        if @album.save

           

            flash[:notice] = ["Album Created"]
            redirect_to band_url(@album.band)
        
    else

        flash[:notice] = @album.errors.full_messages
            redirect_to new_band_band_album_url(@album.band.id)
    end
    end

    def edit
        @albums = BandAlbum.find_by(id:params[:id])
        
        @band = @albums.band if @albums

        @bands = Band.all
        
        @album = BandAlbum.find_by(id:params[:id])
        render :edit

    end

    def update

        @album = BandAlbum.find_by(id:params[:id])

        if @album.update(band_album_params) 

           

            flash[:notice] = ["Album Updated"]
            @album.cover.analyze if @album.cover
            redirect_to band_album_url(@album)
        
    else

        flash[:notice] = @album.errors.full_messages
            redirect_to edit_band_album_url(@album)
         end

    end

    def destroy

        @album = BandAlbum.find_by(id:params[:id])
        @id = @album.band_id
        @album.destroy
        redirect_to band_url(@id)
    end

    private 

    def band_album_params

        params.require(:band_album).permit(:year , :title , :album_type ,:cover )

    end

end