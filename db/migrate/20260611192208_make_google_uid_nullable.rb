class MakeGoogleUidNullable < ActiveRecord::Migration[8.1]
  def change
    change_column_null :people, :google_uid, true
  end
end
