class Meal < ApplicationRecord
  belongs_to :admin

  validates :description, {
    presence: true,
    length: { minimum: 10, maximum: 100 }
  }
  validates :name, presence: true  
  
  
end
