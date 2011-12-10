class CreateOptionsOrderTable < ActiveRecord::Migration
  def self.up
    create_table :options_orders, :id=>false do |t|
      t.references :option, :order
    end
    add_index :options_orders, :option_id
    add_index :options_orders, :order_id
  end

  def self.down
    drop_table :options_orders
    remove_index :options_orders, :option_id
    remove_index :options_orders, :order_id

  end
end
