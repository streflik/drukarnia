class AddOtherFormatToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :other_format, :string
  end

  def self.down
    remove_column :orders, :other_format
  end
end
