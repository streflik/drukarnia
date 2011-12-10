class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.float :value
      t.integer :bracket
      t.integer :color
      t.string :format
      t.timestamps
    end
  end
  
  def self.down
    drop_table :prices
  end
end
