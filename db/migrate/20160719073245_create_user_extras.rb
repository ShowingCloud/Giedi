class CreateUserExtras < ActiveRecord::Migration
  def change
    create_table :user_extras do |t|
      t.references :user, index: true, foreign_key: true
      t.jsonb :info, null: false, default: '{}'
      t.timestamps null: false
    end
  end
end
