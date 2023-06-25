class AdminsController < ApplicationController

    def index
        app_response(data: Admin.all)
    end

    def show
        user = Admin.find_by(id: params[:id])
        if user
            app_response(data: {admin: user, meals: user.meals.as_json})
        end
    end

    def create
        sql = "email = :email"
        user = User.where(sql, {email: user_params[:email]}).first
        if user
            app_response(message: 'Something went wrong during registration', status: :unprocessable_entity)
        else
            user = Admin.create(user_params)
            if user.valid?
                save_user(user.id)
                token = encode(user.id, user.email)
                blob = ActiveStorage::Blob.find(user.id)
                image = url_for(blob)
                user_data = user.as_json.except("created_at", "updated_at","password_digest")
                app_response(message: 'Registration was successful', status: :created, data: {data: user_data, token: token, image: image})
            else
                app_response(message: 'Something went wrong during registration', status: :unprocessable_entity, data: user.errors)
            end
        end
    end

    def login
        sql = 'name = :name OR email = :email'
        user = Admin.where(sql, { name: user_params[:name], email: user_params[:email] }).first
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

    def destroy
        session[:user_id] = nil
        app_response(message: 'Logout successful', status: :ok)
    end

    private
    def user_params
        params.permit(:name, :email, :password, :password_confirmation, :file)
    end
end
