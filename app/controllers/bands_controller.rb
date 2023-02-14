class BandsController < ApplicationController

    before_action :require_user , except: :index

    before_action :band_permission , except: %i(index show new create search )

    def band_search(word)
        
        b= ("%" + word + "%").downcase
        d=[]
        c= Band.where("LOWER(name) LIKE ? " , b )
        c.each {|ele| d << [ele.name , ele.id]}
        return d

    end

    def album_search(word)

        b= ("%" + word + "%").downcase
        d=[]
        c= BandAlbum.where("LOWER(title) LIKE ? OR CAST(year AS varchar) LIKE ?"  , b , b)
        c.each {|ele| d << [ele.title , ele.id]}
        return d

    end

    def track_search(word)

        b= ("%" + word + "%").downcase
        d=[]
        c= Track.where("LOWER(title) LIKE ? OR CAST(ord AS varchar) LIKE ?  OR LOWER(lyrics) LIKE ?" , b , b , b)
        c.each {|ele| d << [ele.title , ele.id]}
        return d

    end

    def search
        @users = User.all.sort_by(&:created_at)
        @bands = Band.all

        word = params[:band][:word] if params[:band]
        flash[:search] = [band_search(word) , album_search(word) , track_search(word)] if word
        redirect_to "/bands"
    end



    def index

        
        @search = flash[:search]
        @users = User.all.sort_by(&:created_at)
        
            @bands = Band.all
        

    end


    def show
        
        @band = Band.find_by(id:params[:id])
        if @band.cover.persisted?
        @cover = url_for(@band.cover)
        @width = @band.cover_width
        @height = @band.cover_height
        end
        @albums = @band.band_albums if @band
        render :show
    end


    def new

        @band = Band.new

        render :new


    end

    def edit
      
        @band = Band.find_by(id:params[:id])
        @albums = @band.band_albums
        render :edit

    end

    def update

        @band = Band.find_by(id:params[:id])
       
        if @band.update(bands_params)


            flash[:notice] = ["Band Updated"]
                redirect_to band_url(@band)
            
        else

            flash[:notice] = @band.errors.full_messages
            redirect_to new_band_url


        end

    end

    def create 

        @band = Band.new(name:params[:band][:name] , user_id:current_user.id , cover:params[:band][:cover])

        if @band.save


                flash[:notice] = ["Band Created"]
                redirect_to bands_url
            
        else

            flash[:notice] = @band.errors.full_messages
            redirect_to new_band_url

        end

    end

    def destroy

        Band.find_by(id:params[:id]).destroy
        redirect_to "/bands"

    end

    private

    def bands_params

        params.require(:band).permit(:name , :word , :cover)

    end

    

end