class MealSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price
  has_one :admin
end
