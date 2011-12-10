class Printtype < ActiveRecord::Base
  has_and_belongs_to_many :options
  has_many :prices
  has_and_belongs_to_many :papers
  has_many :orders
  has_many :formats
end
