class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create_checkout_session
    order = current_user.orders.find(params[:order_id])

    session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      mode: "payment",
      line_items: build_line_items(order),
      success_url: payments_success_url(order_id: order.id, session_id: "{CHECKOUT_SESSION_ID}"),
      cancel_url: payments_cancel_url(order_id: order.id)
    )

    order.update!(stripe_session_id: session.id)

    redirect_to session.url, allow_other_host: true
  end

  def success
    @order = current_user.orders.find(params[:order_id])
  end

  def cancel
    @order = current_user.orders.find(params[:order_id])
  end

  private

  def build_line_items(order)
    order.order_items.map do |item|
      {
        quantity: item.quantity,
        price_data: {
          currency: "cad",
          unit_amount: (item.price_at_purchase * 100).to_i,
          product_data: {
            name: item.product_name
          }
        }
      }
    end + tax_line_items(order)
  end

  def tax_line_items(order)
    tax_items = []

    if order.gst_amount.to_f > 0
      tax_items << {
        quantity: 1,
        price_data: {
          currency: "cad",
          unit_amount: (order.gst_amount * 100).to_i,
          product_data: {
            name: "GST"
          }
        }
      }
    end

    if order.pst_amount.to_f > 0
      tax_items << {
        quantity: 1,
        price_data: {
          currency: "cad",
          unit_amount: (order.pst_amount * 100).to_i,
          product_data: {
            name: "PST"
          }
        }
      }
    end

    if order.hst_amount.to_f > 0
      tax_items << {
        quantity: 1,
        price_data: {
          currency: "cad",
          unit_amount: (order.hst_amount * 100).to_i,
          product_data: {
            name: "HST"
          }
        }
      }
    end

    tax_items
  end

  def success
    @order = current_user.orders.find(params[:order_id])

    if params[:session_id].present?
      stripe_session = Stripe::Checkout::Session.retrieve(params[:session_id])

      if stripe_session.payment_status == "paid"
        @order.update!(
          status: "paid",
          payment_intent_id: stripe_session.payment_intent,
          paid_at: Time.current
        )
      end
    end
  end
end
