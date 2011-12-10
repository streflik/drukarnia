class ChangeFormatInOrder < ActiveRecord::Migration
  def self.up
    change_column :orders, :format, :float
  end

  def self.down
  end
end
