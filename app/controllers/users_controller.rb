class UsersController < ApplicationController

    before_action :require_user , only: %i(show edit )
    before_action :requiere_no_user , only: %i(new create )

    def new

        render :new

    end

    def show

       @user = User.find_by(id:params[:id])
        render :show
    end
   

    def destroy

        check_user

        @user = current_user
        @user.destroy
        redirect_to new_user_url


    end

    def edit

        check_user

        @user = current_user 

     
        render :edit

    end

    def link

        


    end


    def update

        check_user

        @user = current_user 



        return unless params.to_s.include?("pass") || params.to_s.include?("name") || params.to_s.include?("cover")

        if params[:user][:image] 

            if @user.image.attach(params[:user][:image])
                flash[:notice] = ["Done"]
                
                redirect_to edit_user_url
                
            else
            
                redirect_to edit_user_url

            end

        end

         

        if params[:user][:password] 

            if  User.find_by_credentials( @user.email , params[:user][:cur_password]) == @user

                        if @user.update(password:params[:user][:password]) 
                                    
                            flash[:notice] = ["Password changed"]
                            session[:session_token] = @user.session_token
                            redirect_to edit_user_url
                        else
                            flash[:notice] = @user.errors.full_messages
                            redirect_to edit_user_url

                        end

            else        
                flash[:notice] = ["Current password is wrong"]
                redirect_to edit_user_url
                
            end
        end





        if params[:user][:name] 

            if @user.update(name:params[:user][:name])
                flash[:notice] = ["Name changed"]
                redirect_to edit_user_url
                
            else

            flash[:notice] = @user.errors.full_messages
            redirect_to edit_user_url

            end

            end





      


    end

    def activate

        user = User.find_by(id:params[:user][:activation_id])

        if user.active? ==0

            if user.activation_token == params[:user][:activation_token]
                user.update(active?: 1)
                flash[:notice] = ["Welcome #{user.name} click on your email to see your profile"]
                session[:session_token] = user.session_token
                redirect_to bands_url
            end
        else

                flash[:notice] = ["This acc is already activated"]
                redirect_to bands_url


        end



    end

    def create 
        
        user = User.new(
            email: (params[:user][:email]).downcase,
         password: params[:user][:password] ,
          name: params[:user][:name] , active?: 0 ,
          activation_token: SecureRandom.urlsafe_base64(16) 
         
        )
      
        
        @user=user
        user.session_token = User.generate_session_token
        if user.save
            
           
            user.image.attach(io: File.open(Rails.root.join(
                'app', 'assets', 'images', 'avatar.jpg')), filename: 'default-image.png', content_type: 'image/png')

        #    msg = UserMailer.welcome_email(user)
        #    msg.deliver_now
        #    flash[:notice] = ["Verify message has been sent to #{user.email}"]
        session[:session_token] = user.reset_session_token!
           redirect_to bands_url

        else
          
          flash[:notice]  = @user.errors.full_messages
           
            redirect_to new_user_url

        end

    end


    private


    def check_user

        unless current_user == User.find_by(id:params[:id])
            redirect_to bands_url 
            return
            end

    end

    def user_params

        params.require(:user).permit(:email , :password , :name , :cur_password , :activation_token , :activation_id ,:image)

    end

end