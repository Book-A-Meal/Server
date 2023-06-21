class CreateMeals < ActiveRecord::Migration[7.0]
  def change
    create_table :meals do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.integer :price, null: false
      t.belongs_to :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
