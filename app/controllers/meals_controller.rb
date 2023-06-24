class MealsController < ApplicationController

    def index
        meals = Meal.all
        meal = []

        meals.each do | food | 
            admin_info = food.admin
            blob = ActiveStorage::Blob.find(admin_info.id)
            image = url_for(blob)
            admin_data = admin_info.as_json.except("created_at", "updated_at", "password_digest")
            meal_data = food.attributes.merge(admin_data: admin_data, admin_mage: image)

            meal << meal_data
        end
        app_response(data: meal)
    end

    def show
        meal = Meal.find_by(id: params[:id])
        meal_data = meal.as_json.except("created_at", "updated_at")
        if meal
            app_response(data: {meal: meal_data, admin: meal.admin.name.as_json})
        end
    end

    def create
        meal = Meal.create(meal_params)
        app_response(message: 'Meal created successful', status: :created, data: meal)
    end

    private
    def meal_params
        params.permit(:name, :description, :price, :admin_id)
    end
end
