class AddDeviseToPeople < ActiveRecord::Migration[8.1]
  def change
    change_table :people do |t|
      t.string :provider, null: false, default: "google_oauth2"
      t.string :uid,      null: false, default: ""

      # Devise trackable
      t.integer  :sign_in_count,      default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      # Devise rememberable
      t.string :remember_token
      t.datetime :remember_created_at
    end

    add_index :people, [:provider, :uid], unique: true
  end
end
