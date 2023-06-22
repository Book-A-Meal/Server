class UsersController < ApplicationController
    def index
        app_response(data: User.all)
    end

    def show
        user = User.find(params[:id])
        if user
            blob = ActiveStorage::Blob.find(params[:id])
            image = url_for(blob)
            app_response(data: {user: user, image: image})
        end
    end

    def create

        sql = "email = :email"
        user = Admin.where(sql, {email: user_params[:email]}).first
        if user
            app_response(message: 'Something went wrong during registration', status: :unprocessable_entity)
        else

            user = User.create(user_params)
            if user.valid?
                save_user(user.id)
                token = encode(user.id, user.email)
                user_data = user.as_json.except("created_at", "updated_at","password_digest")
                blob = ActiveStorage::Blob.find(user.id)
                image = url_for(blob)
                app_response(message: 'Registration was successful', status: :ok, data: {data: user_data, token: token, image: image})
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
            blob = ActiveStorage::Blob.find(user.id)
            image = url_for(blob)
            user_data = user.as_json.except("created_at", "updated_at","password_digest")
            app_response(message: 'Login was successful', status: :ok, data: { data: user_data, token: token, image: image })
        else
            app_response(message: 'Invalid name/email or password', status: :unprocessable_entity)
        end
    end

    private
    def user_params
        params.permit(:name, :email, :password, :password_confirmation, :file)
    end
end
