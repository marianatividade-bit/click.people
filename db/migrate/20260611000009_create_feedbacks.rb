class CreateFeedbacks < ActiveRecord::Migration[8.1]
  def change
    create_table :feedbacks do |t|
      t.references :giver,    null: false, foreign_key: { to_table: :people }
      t.references :receiver, null: false, foreign_key: { to_table: :people }
      t.references :cycle,    null: true,  foreign_key: true
      t.text       :message,  null: false
      t.integer    :visibility, null: false, default: 0
      t.timestamps
    end
    add_index :feedbacks, :visibility
  end
end
