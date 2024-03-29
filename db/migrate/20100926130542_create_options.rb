class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.string :name
      t.float :price
      t.boolean :per_unit
      t.timestamps
    end
  end
  
  def self.down
    drop_table :options
  end
end
