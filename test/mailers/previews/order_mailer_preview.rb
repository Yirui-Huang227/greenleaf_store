class OrderMailerPreview < ActionMailer::Preview
  def confirmation
    order = Order.find(17)
    OrderMailer.confirmation(order)
  end
end
