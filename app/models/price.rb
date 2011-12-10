class Price < ActiveRecord::Base
  belongs_to :printtype
  belongs_to :format
  validates_numericality_of :value, :bracket
  
end
