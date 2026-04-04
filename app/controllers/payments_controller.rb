class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create_checkout_session
    order = current_user.orders.find(params[:order_id])

    session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      mode:                 "payment",
      line_items:           build_line_items(order),
      success_url:          "http://127.0.0.1:3000/payments/success?order_id=#{order.id}&session_id={CHECKOUT_SESSION_ID}",
      cancel_url:           "http://127.0.0.1:3000/payments/cancel?order_id=#{order.id}"
    )

    order.update!(stripe_payment_id: session.id)

    redirect_to session.url, allow_other_host: true
  end

  def success
    @order = current_user.orders.find_by(id: params[:order_id])

    if @order.nil?
      render plain: "Order not found for id=#{params[:order_id]}", status: :not_found
      return
    end

    return if params[:session_id].blank?

    stripe_session = Stripe::Checkout::Session.retrieve(params[:session_id])

    Rails.logger.debug "=== STRIPE SESSION ID: #{stripe_session.id} ==="
    Rails.logger.debug "=== STRIPE PAYMENT STATUS: #{stripe_session.payment_status} ==="
    Rails.logger.debug "=== STRIPE PAYMENT INTENT: #{stripe_session.payment_intent} ==="

    return unless stripe_session.payment_status == "paid" && @order.status != "paid"

    @order.update!(
      status:            "paid",
      stripe_payment_id: stripe_session.payment_intent
    )
    session[:cart] = {}
    @order.reload
  end

  def cancel
    @order = current_user.orders.find_by(id: params[:order_id])

    return unless @order.nil?

    redirect_to orders_path, alert: "Order not found."
    nil
  end

  private

  def build_line_items(order)
    order.order_items.map do |item|
      {
        quantity:   item.quantity,
        price_data: {
          currency:     "cad",
          unit_amount:  (item.price_at_purchase * 100).to_i,
          product_data: {
            name: item.product_name
          }
        }
      }
    end + tax_line_items(order)
  end

  def tax_line_items(order)
    tax_items = []

    if order.gst_amount.to_f.positive?
      tax_items << {
        quantity:   1,
        price_data: {
          currency:     "cad",
          unit_amount:  (order.gst_amount * 100).to_i,
          product_data: {
            name: "GST"
          }
        }
      }
    end

    if order.pst_amount.to_f.positive?
      tax_items << {
        quantity:   1,
        price_data: {
          currency:     "cad",
          unit_amount:  (order.pst_amount * 100).to_i,
          product_data: {
            name: "PST"
          }
        }
      }
    end

    if order.hst_amount.to_f.positive?
      tax_items << {
        quantity:   1,
        price_data: {
          currency:     "cad",
          unit_amount:  (order.hst_amount * 100).to_i,
          product_data: {
            name: "HST"
          }
        }
      }
    end

    tax_items
  end
end
