class AddFieldsToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :printtype_id, :integer
    add_column :orders, :paper_id, :integer
    add_column :orders, :quantity, :integer
    add_column :orders, :color, :integer
    add_column :orders, :format, :string
    add_column :orders, :number_of_colors1, :integer
    add_column :orders, :number_of_colors2, :integer
    add_column :orders, :dimension, :string
    add_column :orders, :price_id, :integer
  end

  def self.down
    remove_column :orders, :price_id
    remove_column :orders, :dimension
    remove_column :orders, :number_of_colors2
    remove_column :orders, :number_of_colors1
    remove_column :orders, :format
    remove_column :orders, :color
    remove_column :orders, :quantity
    remove_column :orders, :paper_id
    remove_column :orders, :printtype_id
  end
end
