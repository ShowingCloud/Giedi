class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :password_digest

      t.timestamps null: false
    end
    add_index :users, :name
    add_index :users, :email
    add_index :users, :phone
  end
end