class CreateUserExtras < ActiveRecord::Migration
  def change
    create_table :user_extras do |t|
      t.belongs_to :user, index: true, unique: true, foreign_key: true
      t.string :avatar
      t.timestamps null: false
    end
  end
end
