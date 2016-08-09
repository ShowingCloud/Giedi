class AddRegisterFromToUsers < ActiveRecord::Migration
  def change
    add_column :users, :register_from, :string
  end
end
