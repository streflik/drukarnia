class AddUserNameToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :user_name, :string
  end

  def self.down
    remove_column :orders, :user_name
  end
end
