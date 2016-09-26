class AddResetPinToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reset_pin, :string
    add_column :users, :reset_pin_sent_at, :datetime
  end
end
