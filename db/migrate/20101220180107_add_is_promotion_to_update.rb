class AddIsPromotionToUpdate < ActiveRecord::Migration
  def self.up
    add_column :updates, :is_promotion, :boolean
  end

  def self.down
    remove_column :updates, :is_promotion
  end
end
