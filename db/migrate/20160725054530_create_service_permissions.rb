class CreateServicePermissions < ActiveRecord::Migration
  def change
    create_table :service_permissions do |t|
      t.string :name
      t.integer :fullname, limit: 1
      t.integer :gender, limit: 1
      t.integer :birthday, limit: 1
      t.integer :identity_card, limit: 1

      t.timestamps null: false
    end
    add_index :service_permissions, :name
  end
end
