class AddConfirmationSentAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirmation_sent_at, :date
  end
end
