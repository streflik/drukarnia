class Paper < ActiveRecord::Base
  has_and_belongs_to_many :printtypes
  has_many :orders
  validates_numericality_of :price
end
