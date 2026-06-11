class CreatePermissionCaches < ActiveRecord::Migration[8.1]
  def change
    create_table :permission_caches do |t|
      t.references :viewer, null: false, foreign_key: { to_table: :people }
      t.references :target, null: false, foreign_key: { to_table: :people }
      t.integer    :permission, null: false
      t.datetime   :cached_at, null: false
    end

    add_index :permission_caches, [:viewer_id, :target_id, :permission],
              unique: true, name: "idx_permission_caches_unique"
    add_index :permission_caches, :target_id, name: "idx_permission_caches_target"
  end
end
