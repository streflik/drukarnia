class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable,
         :rememberable, :validatable
  has_many :orders, :dependent => :nullify
  validates_presence_of :name, :address, :city, :postcode, :phone





  # Setup accessible (or protected) attributes for your model
#  attr_accessible :email, :password, :password_confirmation
end
