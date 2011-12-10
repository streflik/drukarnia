class AddPrinttypeIdToPrices < ActiveRecord::Migration
  def self.up
    add_column :prices, :printtype_id, :integer
  end

  def self.down
    remove_column :prices, :printtype_id
  end
end
