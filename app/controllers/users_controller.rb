class UsersController < ApplicationController
    def create

        sql = "email = :email"
        user = Admin.where(sql, {email: user_params[:email]}).first
        if user
            app_response(message: 'Something went wrong during registration', status: :unprocessable_entity)
        else

            user = User.create(user_params)
            if user.valid?
                save_user(user.id)
                app_response(message: 'Registration was successful', status: :created, data: user)
            else
                app_response(message: 'Something went wrong during registration', status: :unprocessable_entity, data: user.errors)
            end
        end


    end

    def login
        sql = 'name = :name OR email = :email'
        user = User.where(sql, { name: user_params[:name], email: user_params[:email] }).first
        if user&.authenticate(user_params[:password])
            save_user(user.id)
            token = encode(user.id, user.email)
            user_data = user.as_json.except("created_at", "updated_at","password_digest")
            app_response(message: 'Login was successful', status: :ok, data: { data: user_data, token: token })
        else
            app_response(message: 'Invalid name/email or password', status: :unprocessable_entity)
        end
    end

    private
    def user_params
        params.permit(:name, :email, :password, :password_confirmation)
    end
end
