class MealsController < ApplicationController

    def index
        app_response(data: Meal.all)
    end

    def show
        meal = Meal.joins(:admin).find_by(id: params[:id])
        if meal
            app_response(data: {meal: meal, admin: meal.admin.as_json})
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
