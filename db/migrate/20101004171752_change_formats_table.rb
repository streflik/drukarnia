class ChangeFormatsTable < ActiveRecord::Migration
  def self.up
    add_column :formats, :width, :integer
  end

  def self.down
    remove_column :formats, :width
  end
end
