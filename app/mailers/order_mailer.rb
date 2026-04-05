class OrderMailer < ApplicationMailer
  default from: ENV["MAILER_FROM"]

  def confirmation(order)
    @order = order
    @user = order.user

    mail(
      to:      @user.email,
      subject: "Your Greenleaf Store order confirmation ##{@order.id}"
    )
  end
end
