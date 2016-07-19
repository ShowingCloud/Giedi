class CreateUserExtras < ActiveRecord::Migration
  def change
    create_table :user_extras do |t|
      t.references :user, index: true, foreign_key: true
      t.string :fullname
      t.integer :gender
      t.date :birthday
      t.string :identity_card, limit: 18

      t.timestamps null: false
    end
  end
end
