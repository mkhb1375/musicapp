class LinksController < ApplicationController

    def edit 

        @user = User.find_by(id:params[:user_id])

       

    end


    def update
        @user = User.find_by(id:params[:user_id])

        if User.find_by_credentials(@user.email , params[:link][:cur_password]) == @user

            redirect_to user_confirm_url(@user)

        else
                   
            flash[:notice] = ["Current Password is wrong"]
            session[:session_token] = @user.session_token
            redirect_to edit_user_link_url(@user) 
        end
    end

    private

   def link_params 

    params.require(:link).premit(:cur_password)

   end


end