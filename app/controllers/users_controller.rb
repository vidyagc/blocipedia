class UsersController < ApplicationController

    def show
        @user = User.find(current_user) 
        @wikis = @user.wikis
    end

end 