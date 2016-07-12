class CreatePhoneVerifications < ActiveRecord::Migration
  def change
    create_table :phone_verifications do |t|
      t.string :phone
      t.string :pin

      t.timestamps null: false
    end
  end
end
