class CreatePapersPrinttypesTable < ActiveRecord::Migration
  def self.up
    create_table :papers_printtypes, :id=>false do |t|
      t.references :paper, :printtype
    end
    add_index :papers_printtypes, :paper_id
    add_index :papers_printtypes, :printtype_id
  end

  def self.down
    drop_table :papers_printtypes
    remove_index :papers_printtypes, :paper_id
    remove_index :papers_printtypes, :printtype_id

  end
end