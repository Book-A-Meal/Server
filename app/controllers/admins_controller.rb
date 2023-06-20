class AdminsController < ApplicationController
    def index
        render :json => {message: "Success"}
    end

    def create
        user = Admin.create(user_params)
        if user.valid?
            save_user(user.id)
            app_response(message: 'Registration was successful', status: :created, data: user)
        else
            app_response(message: 'Something went wrong during registration', status: :unprocessable_entity, data: user.errors)
        end
    end

    private
    def user_params
        params.permit(:name, :email, :password, :password_confirmation)
    end
end
