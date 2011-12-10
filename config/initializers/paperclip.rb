Paperclip.interpolates :date do |attachment, style|
  attachment.instance.order.created_at.strftime("%d-%m-%Y")
end
Paperclip.interpolates :order_id do |attachment, style|
  attachment.instance.order.id
end