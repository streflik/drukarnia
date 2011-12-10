class CreateOptionsPrinttypesTable < ActiveRecord::Migration
    def self.up
      create_table :options_printtypes, :id=>false do |t|
        t.references :option, :printtype
      end
      add_index :options_printtypes, :option_id
      add_index :options_printtypes, :printtype_id
    end

    def self.down
      drop_table :options_printtypes
      remove_index :options_printtypes, :option_id
      remove_index :options_printtypes, :printtype_id

    end
  end
