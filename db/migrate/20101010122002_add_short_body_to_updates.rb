class AddShortBodyToUpdates < ActiveRecord::Migration
  def self.up
    add_column :updates, :short_body, :text
  end

  def self.down
    remove_column :updates, :short_body
  end
end
