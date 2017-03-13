class ChangeFieldsInServicePermission < ActiveRecord::Migration
  def change
    remove_column :service_permissions, :fullname, :integer
    remove_column :service_permissions, :gender, :integer
    remove_column :service_permissions, :birthday, :integer
    remove_column :service_permissions, :identity_card, :integer

    add_column :service_permissions, :key_permissions, :jsonb
  end
end
