class MealsController < ApplicationController

    def index
        app_response(data: Meal.all)
    end

    def show
        meal = Meal.find_by(id: params[:id])
        # meal = Meal.joins(:admin).find_by(id: params[:id])
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
