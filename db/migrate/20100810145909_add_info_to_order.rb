class AddInfoToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :info, :text
  end

  def self.down
    remove_column :orders, :info
  end
end
