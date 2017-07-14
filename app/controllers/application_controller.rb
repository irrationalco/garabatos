class ApplicationController < ActionController::Base
   def index
    # the idea is that if the user is not signed in no matter what happens he is redirected to sign in/up
    # if !user_signed_in?
    #   redirect_to user_sign_in_page
    # end
   end
end