class CreatePrinttypes < ActiveRecord::Migration
  def self.up
    create_table :printtypes do |t|
      t.string :name
      t.timestamps
    end
  end
  
  def self.down
    drop_table :printtypes
  end
end
