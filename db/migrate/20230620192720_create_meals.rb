class CreateMeals < ActiveRecord::Migration[7.0]
  def change
    create_table :meals do |t|
      t.string :name
      t.string :description
      t.integer :price
      t.belongs_to :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
