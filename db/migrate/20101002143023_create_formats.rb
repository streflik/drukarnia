class CreateFormats < ActiveRecord::Migration
  def self.up
    create_table :formats do |t|
      t.string :name
      t.integer :value
      t.integer :printtype_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :formats
  end
end
