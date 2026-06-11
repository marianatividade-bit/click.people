class CreateCargos < ActiveRecord::Migration[8.1]
  def change
    create_table :cargos do |t|
      t.string :name
      t.string :level
      t.text :description
      t.boolean :active

      t.timestamps
    end
  end
end
