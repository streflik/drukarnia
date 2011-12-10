class Mailer < ActionMailer::Base
    
  def new_order(order)
    @order = order
   recipients  "streflik@gmail.com" #TODO: zmienic email
    from "admin@drukarnia.megiteam.pl"
   subject  "Nowe zamówienie."
    sent_on Time.now
    content_type "text/html"

  end
  

end
