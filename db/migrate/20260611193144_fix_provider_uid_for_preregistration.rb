class FixProviderUidForPreregistration < ActiveRecord::Migration[8.1]
  def up
    # Remove NOT NULL e default antes de limpar os dados
    change_column :people, :provider, :string, null: true, default: nil
    change_column :people, :uid,      :string, null: true, default: nil

    # Pré-cadastros (sem google_uid) não devem ter provider/uid fictícios
    execute "UPDATE people SET provider = NULL, uid = NULL WHERE google_uid IS NULL"
  end

  def down
    execute "UPDATE people SET provider = 'google_oauth2', uid = '' WHERE provider IS NULL"

    change_column :people, :provider, :string, null: false, default: "google_oauth2"
    change_column :people, :uid,      :string, null: false, default: ""
  end
end
