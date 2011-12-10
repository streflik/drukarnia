class AddNioToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :nip, :string
  end

  def self.down
    remove_column :users, :nip
  end
end
