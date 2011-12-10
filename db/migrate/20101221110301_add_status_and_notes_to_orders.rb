class AddStatusAndNotesToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :status, :string
    add_column :orders, :notes, :text
  end

  def self.down
    remove_column :orders, :notes
    remove_column :orders, :status
  end
end
