class AddFormatFields < ActiveRecord::Migration
  def self.up
    rename_column :orders,:format,:format_id
    rename_column :prices,:format,:format_id
    change_column :orders, :format_id, :integer
    change_column :prices, :format_id, :integer
  end

  def self.down
  end
end
