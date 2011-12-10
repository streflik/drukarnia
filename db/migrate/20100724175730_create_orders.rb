class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :user_id
      t.float :total_price
      t.string :user_email
      t.string :user_address
      t.string :user_city
      t.string :user_postcode
      t.string :user_phone
      t.timestamps
    end
  end
  
  def self.down
    drop_table :orders
  end
end
