class Order < ActiveRecord::Base
#  attr_accessible :user_id, :total_price, :user_email, :user_address, :user_city, :user_postcode, :user_phone
  default_scope :order=>"created_at DESC"
  has_many :images
  belongs_to :user
  belongs_to :printtype
  belongs_to :paper
  belongs_to :format
  has_and_belongs_to_many :options

  validates_presence_of :quantity, :format, :paper
  validates_numericality_of :quantity

  validates_presence_of :user_name,:user_email,:user_address,:user_city,:user_postcode,:user_phone, :on=>:update
  validates_inclusion_of :number_of_colors1,:number_of_colors2, :in=> 0..4, :if=> Proc.new{ |proc| proc.printtype_id==3}

  after_create :write_calculate_price
  attr_accessor :files_count

  def calculate_price

     options.not_per_unit.sum(:price)
    tot=0
    if self.printtype_id==1 #cyfra
       real_qty=(self.quantity.to_f/self.format.value.to_f).ceil
      price=Price.first :conditions => ["? <= bracket and color=?", real_qty, self.color]
      logger.debug price.value
      tot=(paper.price+options.per_unit.sum(:price)+price.value)*real_qty

    elsif self.printtype_id==2 #offset
      price=Price.first :conditions => ["? <= bracket and format_id=?", self.quantity, self.format_id]
      diapl= format.value==1 ? 80 : (format.value==2 ? 50 : (format.value==3 ? 40 : 30)) #diapozytyw
      diapl+= format.value>2 ? 10 : 20 #plyty
      tot=diapl*(self.color==2 ? 2 : self.color==3 ? 4 : self.color==4 ? 5 : self.color==5 ? 8 : 1)
      tot+=price.value*self.quantity*(self.color==2 ? 2 : self.color==3 ? 4 : self.color==4 ? 5 : self.color==5 ? 8 : 1)
      tot+=self.quantity*paper.price

    elsif self.printtype_id==3 #sitodruk
      price=Price.first :conditions => ["? <= bracket and format_id=?", self.quantity, self.format_id]
      dia_p= format.value==1 ? 100 : (format.value==2 ? 100 : format.value==3 ? 80 : (format.value==4 ? 60 : 40)) #diapozytyw  i sito
      dia=dia_p*self.number_of_colors1
      dia+=dia_p*self.number_of_colors2 unless self.number_of_colors2.nil? || self.number_of_colors2==0
      tot+=price.value*self.quantity*self.number_of_colors1
      tot+=price.value*self.quantity*self.number_of_colors2 unless self.number_of_colors2.nil? || self.number_of_colors2==0
      tot+=(self.quantity*paper.price)+dia

    else #wielkoformatowy
      #size #zrobic inny wymiar
      if format.value==1
        x=self.other_format.downcase.split("x")[1].to_i
        y=self.other_format.downcase.split("x")[0].to_i<=60 ? 60 : 100
      else
        y=format.value
        x=format.width
        end
      pap=printtype.papers.first :conditions=>["(name=? and width=?) and width is not null", paper.name, y]
      pap ||= self.paper
      tot=(pap.price*(x.to_f/100))*self.quantity

    end
    tot+options.not_per_unit.sum(:price)+(options.per_unit.sum(:price)*quantity)
  end

  def write_calculate_price
    write_attribute :total_price, calculate_price
    write_attribute :status, "Potwierdzane" if self.status.blank?
    save(false)
  end

end
