class UserMailer < ApplicationMailer

    def welcome_email(user)
        @user = user    
        @url= "/bands"
        @token = user.activation_token
        mail( to:@user.email , subject: "Welcome to MusicApp")

    end

end
