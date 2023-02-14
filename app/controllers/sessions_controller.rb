class SessionsController < ApplicationController

  def new
    
    render :new

  end


  def create 

     user =  User.find_by_credentials((params[:session][:email]).downcase, params[:session][:password])

     if user 

       if user.active? == 0 || user.active? == 1   
              flash[:notice] = ["Welcome back #{user.name}"]
          session[:session_token] = user.reset_session_token!
            redirect_to bands_url
        
        else  
          flash[:notice]  = ["Account is not activated"]
              
          redirect_to new_user_url        
        end
        else

          flash[:notice]  = ["Wrong Creditionals"]
              
                redirect_to new_user_url
     end
  end

  def destroy

    user = current_user
    session[:session_token]=""
    user.reset_session_token!
    redirect_to new_user_url

  end


  private

  def session_params
  params.require(:session).permit(:email , :password)
  end

end