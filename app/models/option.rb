class Option < ActiveRecord::Base
  has_and_belongs_to_many :printtypes
  has_and_belongs_to_many :orders
  named_scope :per_unit, :conditions=>{:per_unit=>true}
  named_scope :not_per_unit, :conditions=>{:per_unit=>false}
end
