class AddNipToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :user_nip, :string
  end

  def self.down
    remove_column :orders, :user_nip
  end
end
